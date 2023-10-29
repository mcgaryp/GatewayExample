//
//  Repository.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public protocol Repository<Payload> {
    associatedtype Payload: Codable
    
    func get() async throws -> Payload
    func set(_: Payload) async
    func refresh() async throws -> Payload
    func clear(cache: Bool) async
}

