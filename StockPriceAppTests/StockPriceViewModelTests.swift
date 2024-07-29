//
//  StockPriceViewModelTests.swift
//  StockPriceAppTests
//
//  Created by Keyur Bhalodiya on 2024/07/29.
//

import XCTest
import Combine
@testable import StockPriceApp

final class StockPriceViewModelTests: XCTestCase {
    var viewModel: StockPriceViewModel!
    var mockDataProvider: MockDataProvider!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockDataProvider = MockDataProvider()
        viewModel = StockPriceViewModel(dataProvider: mockDataProvider)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockDataProvider = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchStockInfo() async {
        let expectation = XCTestExpectation(description: "Fetch stock info")
        
        viewModel.$stockInfo
            .dropFirst()
            .sink { stockInfo in
                XCTAssertNotNil(stockInfo)
                XCTAssertEqual(stockInfo?.stockCode, "AAPL")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchStockInfo(for: "AAPL")
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testRemoveStock() {
        XCTAssertEqual(viewModel.filterStocks, ["AAPL", "GOOGL", "AMZN"])
        
        viewModel.removeStock(stockCode: "GOOGL")
        
        XCTAssertEqual(viewModel.filterStocks, ["AAPL", "AMZN"])
    }
    
    func testSearchStock() {
        viewModel.searchStock(with: "AAPL")
        
        XCTAssertEqual(viewModel.filterStocks, ["AAPL"])
    }
    
    func testDidCancelSearchStock() {
        viewModel.searchStock(with: "AAPL")
        viewModel.didCancelSearchStock()
        
        XCTAssertEqual(viewModel.filterStocks, ["AAPL", "GOOGL", "AMZN"])
    }
}

private extension XCTestCase {
    func fulfillment(of expectations: [XCTestExpectation], timeout seconds: TimeInterval) async {
        await withCheckedContinuation { continuation in
            wait(for: expectations, timeout: seconds)
            continuation.resume()
        }
    }
}
