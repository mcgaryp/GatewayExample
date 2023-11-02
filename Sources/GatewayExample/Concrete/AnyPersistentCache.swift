//
//  AnyPersistentCache.swift
//
//
//  Created by Porter McGary on 11/1/23.
//

import Foundation
import Combine

/// https://medium.com/mobile-app-development-publication/a-guide-to-persistence-storage-in-ios-a8b4f7355486#:~:text=Persistence%20storage%20in%20iOS%20refers,the%20device%20is%20powered%20off.
public actor AnyPersistentCache<Payload: CachePayload>: Cache where Payload.Child: Codable {
    
    private let key: String
    private let container: UserDefaults
    private let lifetime: TimeInterval
    private let store: any DataStore<Payload>
    private let url: URL
    
    private var cancellable: AnyCancellable?
    
    public var current: DataResult<Payload> {
        get async {
            do {
                guard let data = try? Data(contentsOf: url),
                    !expired else { // get a fresh value if expired or uninitialized
                    let result = await store.refresh()
                    if case .success(let payload) = result {
                        try await set(payload)
                    }
                    return result
                }
                
                let child = try JSONDecoder().decode(Payload.Child.self, from: data)
                return .success(Payload(child: child))
            } catch {
                return .failure(error)
            }
        }
    }
    
    public init(store: any DataStore<Payload>,
                key: String = "\(Payload.self)-expiration",
                lifetime: TimeInterval,
                container: UserDefaults = .standard,
                fileURL: URL? = nil) {
        self.key = key
        self.container = container
        self.lifetime = lifetime
        self.store = store
        if let fileURL {
            self.url = fileURL
        } else {
            let url = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: .cachesDirectory, create: true)
            self.url = url.appending(path: key).appendingPathExtension("json")
        }
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
        let jsonData = try JSONEncoder().encode(payload.toChild())
        try jsonData.write(to: url)
        setExpiration()
    }
    
    public func clear() async {
        try? FileManager.default.removeItem(at: url)
        resetExpiration()
    }
    
    public func refresh() async {
        switch await store.refresh() {
        case .failure, .uninitialized:
            return
        case .success(let payload):
            try? await set(payload)
        }
    }
    
    public func sinkWithStore() {
        cancellable = store.publisher.sink { result in
            switch result {
            case .uninitialized, .failure:
                return
            case .success(let payload):
                Task {
                    // TODO: Catch error as necessary
                    try? await self.set(payload)
                }
            }
        }
    }
    
    func resetExpiration() {
        container.removeObject(forKey: key)
    }
    
    func setExpiration() {
        let interval = Date(timeIntervalSinceNow: lifetime).timeIntervalSince1970
        container.set(interval, forKey: key)
    }
    
}
