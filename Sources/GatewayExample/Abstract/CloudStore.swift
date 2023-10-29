//
//  File.swift
//  
//
//  Created by Porter McGary on 10/29/23.
//

import Foundation
import Combine

public protocol CloudStore<Payload> {
    associatedtype Payload
    
    var current: AnyPublisher<DataResult<Payload>, Never> { get }
    
    func sink() async
    func update(_: Payload) async
    func fetch() async throws -> Payload
}

public protocol CloudPayload {
    associatedtype Capture
    
    init(_: Capture)
    
    func toCapture() -> Capture
}
