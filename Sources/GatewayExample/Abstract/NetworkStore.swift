//
//  NetworkStore.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public protocol NetworkStore<Payload> {
    associatedtype Payload: Decodable
    
    func fetch() async throws -> Payload
}
