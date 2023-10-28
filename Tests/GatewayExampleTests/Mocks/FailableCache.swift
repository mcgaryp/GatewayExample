//
//  FailableCache.swift
//  
//
//  Created by Porter McGary on 10/28/23.
//

import Foundation
import GatewayExample

actor FailableCache<Payload: Codable>: Cache {
    
    var shouldFail: Bool
    var current: DataResult<Payload> = .uninitialized
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func set(_ payload: Payload) async throws {
        if shouldFail {
            throw CacheError.failedToStore
        }
        current = .success(payload)
    }
    
    func clear(_: Bool) async {
        guard !shouldFail else { return }
        current = .uninitialized
    }
    
    func setToFail() {
        shouldFail = true
    }
    
    func setToSucceed() {
        shouldFail = false
    }
}
