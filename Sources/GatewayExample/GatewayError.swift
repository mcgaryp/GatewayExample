//
//  File.swift
//  
//
//  Created by Porter McGary on 10/29/23.
//

import Foundation

public enum GatewayError: Error {
    case failedToStore
    case failedFindingValue
    case refreshFailed
}
