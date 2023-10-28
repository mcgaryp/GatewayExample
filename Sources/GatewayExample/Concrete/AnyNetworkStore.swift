//
//  AnyNetworkStore.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public actor AnyNetworkStore<Payload: Decodable>: NetworkStore {
    
    var url: URL
    var timeout: TimeInterval
    
    public init(url: URL, timeout: TimeInterval = 15) {
        self.url = url
        self.timeout = timeout
    }
    
    public func fetch() async throws -> Payload {
        let request = URLRequest(url: url, timeoutInterval: timeout)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else { throw NSError() }
        
        let payload = try JSONDecoder().decode(Payload.self, from: data)
        return payload
    }
    
}
