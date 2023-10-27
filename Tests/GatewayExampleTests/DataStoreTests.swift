//
//  DataStoreTests.swift
//  
//
//  Created by Porter McGary on 10/27/23.
//

import XCTest
@testable import GatewayExample

final class DataStoreTests: XCTestCase {
    
    var store: AnyDataStore<Int>!
    var storeWithPersistent: AnyDataStore<Int>!
    
    override func setUp() {
        let cache = InMemoryCache<Int>()
        store = AnyDataStore(cache: cache)
        let fileURL = FileManager.default.temporaryDirectory.appending(path: "int.json")
        let persistentCache = PersistentCache<Int>(lifetime: 15, file: fileURL)
        let cacheWithPersistentCache = InMemoryCache(persistant: persistentCache)
        storeWithPersistent = AnyDataStore(cache: cacheWithPersistentCache)
    }
    
    func testPublisher() async throws {
        var count = 0
        var result: DataResult<Int> = await store.current
        let cancellable = await store.$current.sink { value in
            count += 1
            result = value
        }
        
        XCTAssertEqual(count, 1)
        XCTAssertEqual(result, .uninitialized)
        
        await store.set(1)
        XCTAssertEqual(count, 2)
        XCTAssertEqual(result, .success(1))
        
        _ = await store.current
        XCTAssertEqual(count, 2)
        XCTAssertEqual(result, .success(1))
        
        await store.set(4)
        XCTAssertEqual(count, 3)
        XCTAssertEqual(result, .success(4))
        
        await store.clear(false)
        XCTAssertEqual(count, 4)
        XCTAssertEqual(result, .uninitialized)
        
        await store.set(4)
        XCTAssertEqual(count, 5)
        XCTAssertEqual(result, .success(4))
        
        throw XCTSkip("TODO: Test when failure")
    }
    
    func testSuccessfulSet() async {
        var result = await store.current
        XCTAssertEqual(result, .uninitialized)
        
        await store.set(1)
        result = await store.current
        switch result {
        case .uninitialized, .failure:
            XCTFail(String(describing: result))
        case .success(let payload):
            XCTAssertEqual(payload, 1)
        }
    }
    
    func testFailedSet() throws {
        throw XCTSkip("TODO")
    }
    
    func testSuccessfulClear() async {
        var result = await store.current
        XCTAssertEqual(result, .uninitialized)
        
        await store.set(1)
        result = await store.current
        switch result {
        case .uninitialized, .failure:
            XCTFail(String(describing: result))
        case .success(let payload):
            XCTAssertEqual(payload, 1)
        }
        
        await store.clear(false)
        result = await store.current
        XCTAssertEqual(result, .uninitialized)
    }
    
    func testFailedClear() throws {
        throw XCTSkip("TODO")
    }
    
    func testPublisherWithPersistentCache() async throws {
        var count = 0
        var result: DataResult<Int> = await storeWithPersistent.current
        let cancellable = await storeWithPersistent.$current.sink { value in
            count += 1
            result = value
        }
        
        XCTAssertEqual(count, 1)
        XCTAssertEqual(result, .uninitialized)
        
        await storeWithPersistent.set(1)
        XCTAssertEqual(count, 2)
        XCTAssertEqual(result, .success(1))
        
        _ = await storeWithPersistent.current
        XCTAssertEqual(count, 2)
        XCTAssertEqual(result, .success(1))
        
        await storeWithPersistent.set(4)
        XCTAssertEqual(count, 3)
        XCTAssertEqual(result, .success(4))
        
        await storeWithPersistent.clear(false)
        XCTAssertEqual(count, 4)
        XCTAssertEqual(result, .uninitialized)
        
        await storeWithPersistent.set(4)
        XCTAssertEqual(count, 5)
        XCTAssertEqual(result, .success(4))
        
        await storeWithPersistent.clear(true)
        XCTAssertEqual(count, 6)
        XCTAssertEqual(result, .uninitialized)
        
        throw XCTSkip("TODO: Test when failure")
    }
    
    func testSuccessfulSetWithPersistentCache() async {
        var result = await storeWithPersistent.current
        XCTAssertEqual(result, .uninitialized)
        
        await storeWithPersistent.set(1)
        result = await storeWithPersistent.current
        switch result {
        case .uninitialized, .failure:
            XCTFail(String(describing: result))
        case .success(let payload):
            XCTAssertEqual(payload, 1)
        }
    }
    
    func testFailedSetWithPersistentCache() throws {
        throw XCTSkip("TODO")
    }
    
    func testSuccessfulClearWithPersistentCacheSetFalse() async {
        var result = await storeWithPersistent.current
        XCTAssertEqual(result, .uninitialized)
        
        await storeWithPersistent.set(1)
        result = await storeWithPersistent.current
        switch result {
        case .uninitialized, .failure:
            XCTFail(String(describing: result))
        case .success(let payload):
            XCTAssertEqual(payload, 1)
        }
        
        await storeWithPersistent.clear(false)
        result = await storeWithPersistent.current
        XCTAssertEqual(result, .uninitialized)
    }
    
    func testSuccessfulClearWithPersistentCacheSetTrue() async {
        var result = await storeWithPersistent.current
        XCTAssertEqual(result, .uninitialized)
        
        await storeWithPersistent.set(1)
        result = await storeWithPersistent.current
        switch result {
        case .uninitialized, .failure:
            XCTFail(String(describing: result))
        case .success(let payload):
            XCTAssertEqual(payload, 1)
        }
        
        await storeWithPersistent.clear(true)
        result = await storeWithPersistent.current
        XCTAssertEqual(result, .uninitialized)
    }
    
    func testFailedClearWithPersistentCache() throws {
        throw XCTSkip("TODO")
    }
    
}
