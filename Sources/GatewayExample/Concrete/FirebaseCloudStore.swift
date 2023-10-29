//
//  FirebaseCloudStore.swift
//  
//
//  Created by Porter McGary on 10/29/23.
//

import Foundation
import FirebaseDatabase
import Combine

public actor FirebaseCloudStore<Payload: CloudPayload>: CloudStore {
    
    public nonisolated var current: AnyPublisher<DataResult<Payload>, Never> {
        _current.eraseToAnyPublisher()
    }
    
    let path: String
    let _current: PassthroughSubject<DataResult<Payload>, Never>
    let ref: DatabaseReference
    
    public init(pathToReference path: String) {
        self.ref = Database.database().reference(withPath: path)
        self.path = path
        self._current = PassthroughSubject<DataResult<Payload>, Never>()
    }
    
    public func sink() {
        ref.observe(.value) { [weak self] snapshot, string  in
            guard let self else { return }
            if let value = snapshot.value as? Payload.Capture {
                Task {
                    await self.update(value)
                }
            }
        }
    }
    
    deinit {
        ref.removeAllObservers()
    }
    
    func update(_ value: Payload.Capture) {
        _current.send(.success(Payload(value)))
    }
    
    public func update(_ value: Payload) {
        ref.setValue(value.toCapture(), forKeyPath: path)
        _current.send(.success(value))
    }
    
    public func fetch() async throws -> Payload {
        guard let capture = ref.value(forKeyPath: path) as? Payload.Capture else {
            _current.send(.failure(GatewayError.failedFindingValue))
            throw GatewayError.failedFindingValue
        }
        let payload = Payload(capture)
        _current.send(.success(Payload(capture)))
        return payload
    }
    
}
