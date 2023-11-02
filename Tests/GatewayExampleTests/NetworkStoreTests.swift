////
////  NetworkStoreTests.swift
////  
////
////  Created by Porter McGary on 10/27/23.
////
//
//import XCTest
//@testable import GatewayExample
//
//final class NetworkStoreTests: XCTestCase {
//
//    var store: AnyNetworkStore<CoinDesk>!
//    
//    override func setUp() {
//        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
//        store = AnyNetworkStore(url: url)
//    }
//    
//    func testSuccessfulFetch() async {
//        do {
//            _ = try await store.fetch()
//        } catch {
//            XCTFail(String(describing: error))
//        }
//    }
//    
//    func testFailedFetch() throws {
//        throw XCTSkip("TODO")
//    }
//
//}
