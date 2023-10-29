//
//  PersistentCache.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public actor PersistentCache<Payload: Codable>: Cache {
    
    private let key = "\(Payload.self)-expiration"
    private let defaults = UserDefaults.standard
    
    let lifetime: TimeInterval
    let file: URL
    
    var expired: Bool {
        guard let date = expirationDate else { return true }
        return .now > date
    }
    
    var expirationDate: Date? {
        guard let interval = defaults.value(forKey: key) as? TimeInterval else { return nil }
        return Date(timeIntervalSince1970: interval)
    }
    
    public var current: DataResult<Payload> {
        self.get()
    }
    
    public init(lifetime: TimeInterval, file: URL) {
        self.lifetime = lifetime
        self.file = file
    }
    
    public func set(_ payload: Payload) async throws {
        do {
            let data = try JSONEncoder().encode(payload)
            try data.write(to: file)
            let date = Date(timeIntervalSinceNow: lifetime)
            defaults.set(date.timeIntervalSince1970, forKey: key)
        } catch {
            throw GatewayError.failedToStore
        }
    }
    
    public func clear(_: Bool) {
        do {
            try FileManager.default.removeItem(at: file)
            defaults.removeObject(forKey: key)
        } catch {
            print(String(describing: error))
        }
    }
    
    func get() -> DataResult<Payload> {
        do {
            guard !expired else { return .uninitialized }
            let data = try Data(contentsOf: file)
            let payload = try JSONDecoder().decode(Payload.self, from: data)
            return .success(payload)
        } catch {
            return .uninitialized
        }
    }
    
}
