//
//  CoinDesk.swift
//  
//
//  Created by Porter McGary on 10/26/23.
//

import Foundation

public struct CoinDesk: Codable, Equatable, NetworkPayload {
    
    public typealias Capture = Self
    
    public init(_ value: CoinDesk) {
        self.init(time: value.time,
                  disclaimer: value.disclaimer,
                  chartName: value.chartName,
                  bpi: value.bpi)
    }
            
    public init(time: Time, disclaimer: String, chartName: String, bpi: BPI) {
        self.time = time
        self.disclaimer = disclaimer
        self.chartName = chartName
        self.bpi = bpi
    }
    
    public var time: Time
    public var disclaimer: String
    public var chartName: String
    public var bpi: BPI
    
    public func toCapture() -> CoinDesk {
        self
    }
}

public struct Time: Codable, Equatable {
    public var updated: String
    public var updatedISO: String
    public var updateduk: String
}

public struct BPI: Codable, Equatable {
    public var USD: BPIObject
    public var GBP: BPIObject
    public var EUR: BPIObject
}

public struct BPIObject: Codable, Equatable {
    public var code: String
    public var symbol: String
    public var rate: String
    public var description: String
    public var rate_float: Double
}
