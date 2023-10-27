//
//  DataResult.swift
//
//
//  Created by Porter McGary on 10/27/23.
//

import Foundation

public enum DataResult<Payload>: Equatable {
    case uninitialized
    case failure(Error)
    case success(Payload)
    
    public static func == (lhs: DataResult<Payload>, rhs: DataResult<Payload>) -> Bool {
        switch lhs {
        case .uninitialized:
            if case .uninitialized = rhs {
                return true
            }
            return false
        case .failure:
            if case .failure = rhs {
                return true
            } else { return false }
        case .success:
            if case .success = rhs {
                return true
            }
            return false
        }
    }
}
