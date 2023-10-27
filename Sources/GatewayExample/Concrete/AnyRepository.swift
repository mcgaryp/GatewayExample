//
//  Repository.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public actor AnyRepository<Payload: Codable>: Repository {
    
    var store: any DataStore<Payload>
    var network: any NetworkStore<Payload>
    
    init(store: any DataStore<Payload>, network: any NetworkStore<Payload>) {
        self.store = store
        self.network = network
    }
    
    func get() async throws -> Payload {
        switch await store.current {
        case .uninitialized:
            return try await refresh()
        case .success(let payload):
            return payload
        case .failure(let error):
            throw error
        }
    }
    
    func set(_ payload: Payload) async {
        await store.set(payload)
    }
    
    func refresh() async throws -> Payload {
        let payload = try await network.fetch()
        await store.set(payload)
        return payload
    }
    
    func clear(cache: Bool = false) async  {
        await store.clear(cache)
    }
    
}
