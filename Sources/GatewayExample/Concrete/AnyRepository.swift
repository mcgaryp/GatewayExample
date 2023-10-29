//
//  Repository.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation
import FirebaseDatabase
import Combine

public actor AnyRepository<Payload: Codable>: Repository {
    
    var store: any DataStore<Payload>
    var network: (any NetworkStore<Payload>)?
    var cloud: (any CloudStore<Payload>)?
    
    public init(store: any DataStore<Payload>) {
        self.store = store
        self.network = nil
        self.cloud = nil
    }
    
    public init(store: any DataStore<Payload>, network: any NetworkStore<Payload>) 
    where Payload: NetworkPayload {
        self.store = store
        self.network = network
        self.cloud = nil
    }
    
    public init(store: any DataStore<Payload>, cloud: any CloudStore<Payload>)
    where Payload: CloudPayload {
        self.store = store
        self.network = nil
        self.cloud = cloud
        Task {
            await sinkCloud()
        }
    }
    
    public init(store: any DataStore<Payload>, network: any NetworkStore<Payload>, cloud: any CloudStore<Payload>)
    where Payload: CloudPayload & NetworkPayload {
        self.store = store
        self.network = network
        self.cloud = cloud
        Task {
            await sinkCloud()
        }
    }
    
    // TODO:
    func sinkCloud() async  {
//        await cloud?.sink()
//        let current = await store.$current
//        await cloud?.current.assign(to: &current)
    }
    
    public func get() async throws -> Payload {
        switch await store.current {
        case .uninitialized:
            return try await refresh()
        case .success(let payload):
            return payload
        case .failure(let error):
            throw error
        }
    }
    
    public func set(_ payload: Payload) async {
        await store.set(payload)
    }
    
    public func refresh() async throws -> Payload {
        let payload: Payload
        if let network {
            payload = try await network.fetch()
        } else if let cloud {
            payload = try await cloud.fetch()
        } else {
            switch await store.current {
            case .failure(let error):
                throw error
            case .success(let value):
                payload = value
            case .uninitialized:
                throw GatewayError.refreshFailed
            }
        }
        
        await store.set(payload)
        return payload
    }
    
    public func clear(cache: Bool = false) async  {
        await store.clear(cache)
    }
    
}
