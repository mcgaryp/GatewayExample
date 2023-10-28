//
//  File.swift
//  
//
//  Created by Porter McGary on 10/26/23.
//

import Foundation

public struct CoinDesk: Codable, Equatable {
    var time: Time
    var disclaimer: String
    var chartName: String
    var bpi: BPI
}

public struct Time: Codable, Equatable {
    var updated: String
    var updatedISO: String
    var updateduk: String
}

public struct BPI: Codable, Equatable {
    var USD: BPIObject
    var GBP: BPIObject
    var EUR: BPIObject
}

public struct BPIObject: Codable, Equatable {
    var code: String
    var symbol: String
    var rate: String
    var description: String
    var rate_float: Double
}
