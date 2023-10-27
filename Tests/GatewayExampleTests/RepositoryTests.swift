import XCTest
@testable import GatewayExample

final class RepositoryTests: XCTestCase {
    
    var perCache: PersistentCache<CoinDesk>!
    var memCache: InMemoryCache<CoinDesk>!
    var store: AnyDataStore<CoinDesk>!
    var network: AnyNetworkStore<CoinDesk>!
    var repository: AnyRepository<CoinDesk>!
    
    override func setUp() {
        let networkURL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        let fileURL = FileManager.default.temporaryDirectory.appending(path: "coindesk.json")
        perCache = PersistentCache(lifetime: 60, file: fileURL)
        memCache = InMemoryCache(persistant: perCache)
        store = AnyDataStore(cache: memCache)
        network = AnyNetworkStore(url: networkURL)
        repository = AnyRepository(store: store, network: network)
    }
    
    func testSuccessfulGet() async {
        let current = await repository.store.current
        XCTAssertEqual(current, .uninitialized)
        let result = try? await repository.get()
        XCTAssertNotNil(result)
    }
    
    func testFailedGet() throws {
        throw XCTSkip("TODO")
    }
    
    func testSuccessfulSet() async throws {
        let expected = CoinDesk(time: Time(updated: "example", updatedISO: "example", updateduk: "example"), disclaimer: "example", chartName: "example", bpi: BPI(USD: BPIObject(code: "example", symbol: "example", rate: "example", description: "example", rate_float: 1), GBP: BPIObject(code: "example", symbol: "example", rate: "example", description: "example", rate_float: 1), EUR: BPIObject(code: "example", symbol: "example", rate: "example", description: "example", rate_float: 1)))
        
        await repository.set(expected)
        let result = try await repository.get()
        XCTAssertEqual(result, expected)
    }
    
    func testFailedSet() throws {
        throw XCTSkip("TODO")
    }
    
    func testSuccessfulRefresh() async throws {
        let current = CoinDesk(time: Time(updated: "example", updatedISO: "example", updateduk: "example"), disclaimer: "example", chartName: "example", bpi: BPI(USD: BPIObject(code: "example", symbol: "example", rate: "example", description: "example", rate_float: 1), GBP: BPIObject(code: "example", symbol: "example", rate: "example", description: "example", rate_float: 1), EUR: BPIObject(code: "example", symbol: "example", rate: "example", description: "example", rate_float: 1)))
        let expected = try await repository.get()
        await repository.set(current)
        var result = try await repository.get()
        XCTAssertEqual(result, current)
        result = try await repository.refresh()
        XCTAssertEqual(result, expected)
    }
    
    func testFailedRefresh() throws {
        throw XCTSkip("TODO")
    }
    
    func testSuccessfulClear() async {
        var result = try? await repository.get()
        XCTAssertNotNil(result)
        var currentInMemoryCache = await repository.store.cache.current
//        var currentPersistentCache = await repository.store.cache.cache?.get()
        XCTAssertEqual(currentInMemoryCache, .success(result!))
//        XCTAssertEqual(currentPersistentCache, .success(result!))
        
        await repository.clear()
        
        currentInMemoryCache = await repository.store.cache.current
//        currentPersistentCache = await repository.store.cache.cache?.get()
        XCTAssertEqual(currentInMemoryCache, .uninitialized)
//        XCTAssertEqual(currentPersistentCache, .success(result!))
        
        result = try? await repository.refresh()
        currentInMemoryCache = await repository.store.cache.current
//        currentPersistentCache = await repository.store.cache.cache?.get()
        XCTAssertEqual(currentInMemoryCache, .success(result!))
//        XCTAssertEqual(currentPersistentCache, .success(result!))
        
        await repository.clear(cache: true)
        
        currentInMemoryCache = await repository.store.cache.current
//        currentPersistentCache = await repository.store.cache.cache?.get()
        XCTAssertEqual(currentInMemoryCache, .uninitialized)
//        XCTAssertEqual(currentPersistentCache, .uninitialized)
    }
    
    func testFailedClear() throws {
        throw XCTSkip("TODO")
    }
    
}
