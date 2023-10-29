//
//  Cache.swift
//
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public protocol Cache<Payload> {
    associatedtype Payload: Codable
    
    var current: DataResult<Payload> { get async }
    
    func set(_: Payload) async throws
    func clear(_: Bool) async
}

public extension Cache {
    func clear(cache: Bool = false) async {
        await clear(cache)
    }
}
