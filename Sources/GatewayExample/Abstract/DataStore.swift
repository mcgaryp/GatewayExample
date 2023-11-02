//
//  DataStore.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation
import Combine

public protocol DataStore<Payload> {
    associatedtype Payload
    
    var publisher: AnyPublisher<DataResult<Payload>, Never> { get }
    
    func sink(_: AnyPublisher<DataResult<Payload>, Never>) async
    func refresh() async -> DataResult<Payload>
}
