//
//  NetworkStore.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public protocol NetworkStore<Payload> {
    associatedtype Payload
    
    func fetch() async throws -> Payload
}

public protocol NetworkPayload {
    associatedtype Capture: Decodable
    
    init(_: Capture)
    
    func toCapture() -> Capture
}
