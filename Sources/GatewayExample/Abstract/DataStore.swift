//
//  DataStore.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

protocol DataStore<Payload> {
    associatedtype Payload: Codable
    
    var cache: any Cache<Payload> { get async }
    var current: DataResult<Payload> { get async }
    
    func set(_: Payload) async
    func clear(_: Bool) async
}
