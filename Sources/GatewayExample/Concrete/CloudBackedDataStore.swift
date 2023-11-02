//
//  CloudBackedDataStore.swift
//
//
//  Created by Porter McGary on 11/1/23.
//

import Foundation
import Combine

public actor CloudBackedDataStore<Payload: DataStorePayload>: DataStore where Payload.DataStoreObject: Codable {
    
    let url: URL
    let timeout: TimeInterval
    let _current: PassthroughSubject<DataResult<Payload>, Never>
    
    var cancellable: AnyCancellable?
    
    public nonisolated var publisher: AnyPublisher<DataResult<Payload>, Never> {
        _current.eraseToAnyPublisher()
    }
    
    public init(url: URL, timeout: TimeInterval) {
        self.url = url
        self.timeout = timeout
        self._current = PassthroughSubject<DataResult<Payload>, Never>()
    }
    
    public func sink(_ publisher: AnyPublisher<DataResult<Payload>, Never>) {
        cancellable = publisher.sink { [weak self] result in
            guard let self else { return }
            self._current.send(result)
        }

    }
    
    public func refresh() async -> DataResult<Payload> {
        do {
            guard let value = try await fetch() else {
                return .uninitialized
            }
            return .success(value)
        } catch {
            return .failure(error)
        }
    }
    
    func fetch() async throws -> Payload? {
        let request = URLRequest(url: url, timeoutInterval: timeout)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            // TODO: Throw an error
            return nil
        }
        
        let child = try JSONDecoder().decode(Payload.DataStoreObject.self, from: data)
        return Payload(child)
    }
}
