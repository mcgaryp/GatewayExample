//
//  InMemoryCache.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public actor InMemoryCache<Payload: Codable>: Cache {
    
    private var _current: DataResult<Payload> = .uninitialized
    
    var current: DataResult<Payload> {
        get async {
            if let cache {
                guard await cache.expired else {
                    return _current
                }
                return .uninitialized
            } else {
                return _current
            }
        }
    }
    
    var cache: PersistentCache<Payload>?
    
    init(persistant cache: PersistentCache<Payload>? = nil) {
        self.cache = cache
    }
    
    func set(_ payload: Payload) async throws {
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
    
    func clear(_ persistent: Bool) async  {
        if let cache, persistent {
            await cache.clear()
        }
        _current = .uninitialized
    }
    
}
