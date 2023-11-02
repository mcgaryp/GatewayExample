////
////  InMemoryCacheTests.swift
////  
////
////  Created by Porter McGary on 10/27/23.
////
//
//import XCTest
//@testable import GatewayExample
//
//final class InMemoryCacheTests: XCTestCase {
//
//    
//    func testSuccessfulSet() async {
//        let cache = InMemoryCache<Int>()
//        var result = await cache.current
//        XCTAssertEqual(result, .uninitialized)
//        
//        try? await cache.set(1)
//        result = await cache.current
//        switch result {
//        case .uninitialized, .failure:
//            XCTFail(String(describing: result))
//        case .success(let payload):
//            XCTAssertEqual(payload, 1)
//        }
//    }
//    
//    func testFailedSet() throws {
//        throw XCTSkip("TODO")
//    }
//    
//    func testSuccessfulClear() async {
//        let cache = InMemoryCache<Int>()
//        var result = await cache.current
//        XCTAssertEqual(result, .uninitialized)
//        
//        try? await cache.set(1)
//        result = await cache.current
//        switch result {
//        case .uninitialized, .failure:
//            XCTFail(String(describing: result))
//        case .success(let payload):
//            XCTAssertEqual(payload, 1)
//        }
//        
//        await cache.clear(false)
//        
//        result = await cache.current
//        XCTAssertEqual(result, .uninitialized)
//    }
//    
//    func testFailedClear() throws {
//        throw XCTSkip("TODO")
//    }
//    
//    func testSuccessfulSetWithPersistentCache() async {
//        let fileURL = FileManager.default.temporaryDirectory.appending(path: "int-1.json")
//        let persistentCache = PersistentCache<Int>(lifetime: 15, file: fileURL)
//        let cacheWithPersistent = InMemoryCache<Int>(persistent: persistentCache)
//        
//        var result = await cacheWithPersistent.current
//        XCTAssertEqual(result, .uninitialized)
//        
//        try? await cacheWithPersistent.set(1)
//        result = await cacheWithPersistent.current
//        switch result {
//        case .uninitialized, .failure:
//            XCTFail(String(describing: result))
//        case .success(let payload):
//            XCTAssertEqual(payload, 1)
//        }
//    }
//    
//    func testFailedSetWithPersistentCache() throws {
//        throw XCTSkip("TODO")
//        let fileURL = FileManager.default.temporaryDirectory.appending(path: "int-2.json")
//        let persistentCache = PersistentCache<Int>(lifetime: 15, file: fileURL)
//        let cacheWithPersistent = InMemoryCache<Int>(persistent: persistentCache)
//    }
//    
//    func testSuccessfulClearWithPersistentCacheSetToFalse() async {
//        let fileURL = FileManager.default.temporaryDirectory.appending(path: "int-3.json")
//        let persistentCache = PersistentCache<Int>(lifetime: 15, file: fileURL)
//        let cacheWithPersistent = InMemoryCache<Int>(persistent: persistentCache)
//        
//        var result = await cacheWithPersistent.current
//        XCTAssertEqual(result, .uninitialized)
//        
//        try? await cacheWithPersistent.set(1)
//        result = await cacheWithPersistent.current
//        switch result {
//        case .uninitialized, .failure:
//            XCTFail(String(describing: result))
//        case .success(let payload):
//            XCTAssertEqual(payload, 1)
//        }
//        
//        await cacheWithPersistent.clear(false)
//        
//        result = await cacheWithPersistent.current
//        XCTAssertEqual(result, .uninitialized)
//    }
//    
//    func testSuccessfulClearWithPersistentCacheSetToTrue() async {
//        let fileURL = FileManager.default.temporaryDirectory.appending(path: "int-4.json")
//        let persistentCache = PersistentCache<Int>(lifetime: 15, file: fileURL)
//        let cacheWithPersistent = InMemoryCache<Int>(persistent: persistentCache)
//        
//        var result = await cacheWithPersistent.current
//        XCTAssertEqual(result, .uninitialized)
//        
//        try? await cacheWithPersistent.set(1)
//        result = await cacheWithPersistent.current
//        switch result {
//        case .uninitialized, .failure:
//            XCTFail(String(describing: result))
//        case .success(let payload):
//            XCTAssertEqual(payload, 1)
//        }
//        
//        await cacheWithPersistent.clear(true)
//        
//        result = await cacheWithPersistent.current
//        XCTAssertEqual(result, .uninitialized)
//    }
//    
//    func testFailedClearWithPersistentCache() throws {
//        throw XCTSkip("TODO")
//        let fileURL = FileManager.default.temporaryDirectory.appending(path: "int-5.json")
//        let persistentCache = PersistentCache<Int>(lifetime: 15, file: fileURL)
//        let cacheWithPersistent = InMemoryCache<Int>(persistent: persistentCache)
//    }
//    
//}
