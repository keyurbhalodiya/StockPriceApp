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
  
  func testFetchStockInfoFailed() async {
    let expectation = XCTestExpectation(description: "Fetch stock info failed")
    
    viewModel.$showingAlert
      .dropFirst()
      .sink { showingAlert in
        XCTAssertEqual(showingAlert, true)
        XCTAssertNil(self.viewModel.stockInfo)
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    viewModel.fetchStockInfo(for: "9434")
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func testStockInfoPropetyValues() async {
    let expectation = XCTestExpectation(description: "Fetch stock info and varify StockInfo Propeties Values")
    
    viewModel.$stockInfo
      .dropFirst()
      .sink { stockInfo in
        XCTAssertNotNil(stockInfo)
        XCTAssertEqual(stockInfo?.stockCode, "AAPL")
        XCTAssertEqual(stockInfo?.rowModel[0].title, "前日終值")
        XCTAssertEqual(stockInfo?.rowModel[0].value, "218.0$")
        XCTAssertEqual(stockInfo?.rowModel[1].title, "始值")
        XCTAssertEqual(stockInfo?.rowModel[1].value, "216.7$")
        XCTAssertEqual(stockInfo?.rowModel[2].title, "高值")
        XCTAssertEqual(stockInfo?.rowModel[2].value, "219.3$")
        XCTAssertEqual(stockInfo?.rowModel[3].title, "安值")
        XCTAssertEqual(stockInfo?.rowModel[3].value, "215.8$")
        XCTAssertEqual(stockInfo?.rowModel[4].title, "出来高")
        XCTAssertEqual(stockInfo?.rowModel[4].value, "11,790,954株")
        XCTAssertEqual(stockInfo?.rowModel[5].title, "52週高值")
        XCTAssertEqual(stockInfo?.rowModel[5].value, "219.3$")
        XCTAssertEqual(stockInfo?.rowModel[6].title, "52週安值")
        XCTAssertEqual(stockInfo?.rowModel[6].value, "215.8$")
        
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    viewModel.fetchStockInfo(for: "AAPL")
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func testStockChartPropetyValues() async {
    let expectation = XCTestExpectation(description: "Fetch stock info and varify StockChart Propeties Values")
    
    viewModel.$stockChart
      .dropFirst()
      .sink { stockChart in
        XCTAssertNotNil(stockChart)
        XCTAssertEqual(stockChart?.count, 85)
        XCTAssertEqual(stockChart?.first?.close, 216.67999267578125)
        XCTAssertEqual(stockChart?.first?.timestamp, 1722259800.0)
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    viewModel.fetchStockInfo(for: "AAPL")
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func testFilterStocksWithNewSymbol() async {
    let expectation = XCTestExpectation(description: "Filter Stocks should add new symbol")
    
    viewModel.$filterStocks
      .dropFirst()
      .sink { filterStocks in
        XCTAssertEqual(filterStocks, ["YMM", "GOOGL", "AMZN", "AAPL"])
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    viewModel.fetchStockInfo(for: "AAPL")
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func testFilterStocksWithExistingSymbol() async {
    let expectation = XCTestExpectation(description: "Filter Stocks shouldn't add new symbol")
    
    viewModel.$stockInfo
      .dropFirst()
      .sink { _ in
        XCTAssertEqual(self.viewModel.filterStocks, ["YMM", "GOOGL", "AMZN"])
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    viewModel.fetchStockInfo(for: "YMM")
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func testRemoveStock() {
    XCTAssertEqual(viewModel.filterStocks, ["YMM", "GOOGL", "AMZN"])
    
    viewModel.removeStock(stockCode: "GOOGL")
    
    XCTAssertEqual(viewModel.filterStocks, ["YMM", "AMZN"])
  }
  
  func testSearchStock() {
    viewModel.searchStock(with: "YMM")
    
    XCTAssertEqual(viewModel.filterStocks, ["YMM"])
  }
  
  func testDidCancelSearchStock() {
    viewModel.searchStock(with: "YMM")
    viewModel.didCancelSearchStock()
    
    XCTAssertEqual(viewModel.filterStocks, ["YMM", "GOOGL", "AMZN"])
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
