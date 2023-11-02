//
//  Cache.swift
//
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation
import Combine

public protocol Cache<Payload> {
    associatedtype Payload
    
    var publisher: AnyPublisher<DataResult<Payload>, Never> { get }
    var current: DataResult<Payload> { get async }
    var expired: Bool { get async }
    
    func set(_: Payload) async throws
    func sinkWithStore() async
    func clear() async
    func refresh() async
}
