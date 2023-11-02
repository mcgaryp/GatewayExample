//
//  NetworkPayload.swift
//  
//
//  Created by Porter McGary on 11/1/23.
//

import Foundation

public protocol NetworkPayload {
    associatedtype NetworkObject
    
    init(_: NetworkObject)
    
    func toNetworkObject() -> NetworkObject
}
