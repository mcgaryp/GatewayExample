//
//  AnyInMemoryCache.swift
//
//
//  Created by Porter McGary on 11/1/23.
//

import Foundation
import Combine

public actor AnyInMemoryCache<Payload>: Cache {
    
    private let key: String
    private let container: UserDefaults
    private let lifetime: TimeInterval
    private let store: any DataStore<Payload>
    
    private var cancellable: AnyCancellable?
    
    public var current: DataResult<Payload> = .uninitialized
    
    public init(store: any DataStore<Payload>,
                key: String = "\(Payload.self)-expiration",
                lifetime: TimeInterval,
                container: UserDefaults = .standard) {
        self.key = key
        self.container = container
        self.lifetime = lifetime
        self.store = store
    }
    
    public var expired: Bool {
        guard let date = expirationDate else { return true }
        return .now > date
    }
    
    public nonisolated var publisher: AnyPublisher<DataResult<Payload>, Never> {
        store.publisher
    }
    
    var expirationDate: Date? {
        guard let interval = container.value(forKey: key) as? TimeInterval
        else { return nil }
        return Date(timeIntervalSince1970: interval)
    }
    
    public func set(_ payload: Payload) async throws {
        // TODO: Set the value in the datastore if necessary
        current = .success(payload)
        setExpiration()
    }
    
    public func clear() async {
        current = .uninitialized
        resetExpiration()
    }
    
    public func refresh() async {
        current = await store.refresh()
        setExpiration()
    }
    
    public func sinkWithStore() {
        cancellable = store.publisher.sink { result in
            self.current = result
        }
    }
    
    func set(_ result: DataResult<Payload>) {
        current = result
    }
    
    func resetExpiration() {
        container.removeObject(forKey: key)
    }
    
    func setExpiration() {
        let interval = Date(timeIntervalSinceNow: lifetime).timeIntervalSince1970
        container.set(interval, forKey: key)
    }
    
}
