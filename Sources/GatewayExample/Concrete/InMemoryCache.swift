//
//  InMemoryCache.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public actor InMemoryCache<Payload: Codable>: Cache {
    
    private var _current: DataResult<Payload> = .uninitialized
    
    public var current: DataResult<Payload> {
        get async {
            if let cache = cache as? PersistentCache<Payload> {
                guard await cache.expired else {
                    return _current
                }
                return .uninitialized
            } else {
                return _current
            }
        }
    }
    
    var cache: (any Cache<Payload>)?
    
    public init(persistent cache: (any Cache<Payload>)? = nil) {
        self.cache = cache
    }
    
    public func set(_ payload: Payload) async throws {
        if let cache {
            do {
                try await cache.set(payload)
                _current = .success(payload)
            } catch {
                _current = .failure(error)
                throw error
            }
        } else {
            _current = .success(payload)
        }
    }
    
    public func clear(_ persistent: Bool) async  {
        if let cache, persistent {
            await cache.clear()
            _current = await cache.current
        } else {
            _current = .uninitialized
        }
    }
    
}
