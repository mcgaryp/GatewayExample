//
//  CachePayload.swift
//  
//
//  Created by Porter McGary on 11/1/23.
//

import Foundation

public protocol CachePayload {
    associatedtype CacheObject
    
    init(_: CacheObject)
    
    func toCacheObject() -> CacheObject
}
