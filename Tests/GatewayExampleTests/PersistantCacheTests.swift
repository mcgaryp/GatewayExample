//
//  PersistantCacheTests.swift
//
//
//  Created by Porter McGary on 10/27/23.
//

import XCTest
@testable import GatewayExample

final class PersistantCacheTests: XCTestCase {
    
    func testExpired() async throws {
        let url = FileManager.default.temporaryDirectory.appending(path: "int-1.json")
        let store = PersistentCache<Int>(lifetime: 15, file: url)
        await store.clear()
        var isExpired = await store.expired
        XCTAssertTrue(isExpired)
        try await store.set(1)
        isExpired = await store.expired
        XCTAssertFalse(isExpired)
        try? await Task.sleep(for: .seconds(16))
        isExpired = await store.expired
        XCTAssertTrue(isExpired)
    }
    
    func testExpirationDate() throws {
        throw XCTSkip("TODO")
        let url = FileManager.default.temporaryDirectory.appending(path: "int-2.json")
        let store = PersistentCache<Int>(lifetime: 15, file: url)
    }
    
    func testSuccessfulSet() async {
        let url = FileManager.default.temporaryDirectory.appending(path: "int-3.json")
        let store = PersistentCache<Int>(lifetime: 15, file: url)
        let result = await store.current
        XCTAssertEqual(result, .uninitialized)
        
        do {
            try await store.set(1)
        } catch {
            XCTFail(String(describing: error))
        }
        
        let data = try? Data(contentsOf: url)
        XCTAssertNotNil(data)
        let number = try? JSONDecoder().decode(Int.self, from: data!)
        XCTAssertEqual(number, 1)
    }
    
    func testFailedSet() throws {
        throw XCTSkip("TODO")
        let url = FileManager.default.temporaryDirectory.appending(path: "int-4.json")
        let store = PersistentCache<Int>(lifetime: 15, file: url)
    }
    
    func testSuccesfulGet() async {
        let url = FileManager.default.temporaryDirectory.appending(path: "int-5.json")
        let store = PersistentCache<Int>(lifetime: 15, file: url)
        var result = await store.current
        XCTAssertEqual(result, .uninitialized)
        
        do {
            try await store.set(1)
        } catch {
            XCTFail(String(describing: error))
        }
        
        result = await store.current
        switch result {
        case .uninitialized, .failure:
            XCTFail(String(describing: result))
        case .success(let payload):
            XCTAssertEqual(payload, 1)
        }
        
        try? await Task.sleep(for: .seconds(16))
        
        result = await store.current
        XCTAssertEqual(result, .uninitialized)
    }
    
    func testFailedGet() throws {
        throw XCTSkip("TODO")
        let url = FileManager.default.temporaryDirectory.appending(path: "int-6.json")
        let store = PersistentCache<Int>(lifetime: 15, file: url)
    }
    
    func testSuccessfulClear() async {
        let url = FileManager.default.temporaryDirectory.appending(path: "int-7.json")
        let store = PersistentCache<Int>(lifetime: 15, file: url)
        var result = await store.current
        XCTAssertEqual(result, .uninitialized)
        
        do {
            try await store.set(1)
        } catch {
            XCTFail(String(describing: error))
        }
        
        result = await store.current
        switch result {
        case .uninitialized, .failure:
            XCTFail(String(describing: result))
        case .success(let payload):
            XCTAssertEqual(payload, 1)
        }
        
        await store.clear()
        
        let data = try? Data(contentsOf: url)
        XCTAssertNil(data)
        
        result = await store.current
        XCTAssertEqual(result, .uninitialized)
        
        let isExpired = await store.expired
        XCTAssertTrue(isExpired)
    }
    
    func testFailedClear() throws {
        throw XCTSkip("TODO")
        let url = FileManager.default.temporaryDirectory.appending(path: "int-8.json")
        let store = PersistentCache<Int>(lifetime: 15, file: url)
    }
    
}
