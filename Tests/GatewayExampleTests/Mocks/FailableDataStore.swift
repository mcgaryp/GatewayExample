//
//  File.swift
//  
//
//  Created by Porter McGary on 10/28/23.
//

import Foundation
import GatewayExample

actor FailableDataStore<Payload: Codable>: DataStore {
    
    var shouldFail: Bool
    var cache: any Cache<Payload>
    var current: DataResult<Payload> = .uninitialized
    
    init(shouldFail: Bool, cache: any Cache<Payload>) {
        self.shouldFail = shouldFail
        self.cache = cache
    }
    
    func set(_ payload: Payload) async {
        if shouldFail {
            current = .failure(CacheError.failedToStore)
        }
        current = .success(payload)
    }
    
    func clear(_ cache: Bool) async {
        guard !shouldFail else { return }
        if cache {
            await self.cache.clear(cache: cache)
        }
        current = .uninitialized
    }
}
