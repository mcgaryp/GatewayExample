//
//  DataStorePayload.swift
//  
//
//  Created by Porter McGary on 11/1/23.
//

import Foundation

public protocol DataStorePayload {
    associatedtype DataStoreObject
    
    init(_: DataStoreObject)
    
    func toDataStoreObject() -> DataStoreObject
}
