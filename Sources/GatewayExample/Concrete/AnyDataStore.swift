//
//  AnyDataStore.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public actor AnyDataStore<Payload: Codable>: DataStore {
    
    @Published var current: DataResult<Payload> = .uninitialized
    
    var cache: any Cache<Payload>
    
    init(cache: any Cache<Payload>) {
        self.cache = cache
    }
    
    func set(_ payload: Payload) async {
        do {
            try await cache.set(payload)
            current = await cache.current
        } catch {
            current = .failure(error)
        }
    }
    
    func clear(_ persistent: Bool) async {
        await cache.clear(persistent)
        current = await cache.current
    }
    
}
