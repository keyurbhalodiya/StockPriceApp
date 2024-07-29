//
//  MockDataProvider.swift
//  StockPriceAppTests
//
//  Created by Keyur Bhalodiya on 2024/07/29.
//

import XCTest
import Combine
@testable import StockPriceApp

final class MockDataProvider: DataProviding {
    var cacheStocks: [String] = ["AAPL", "GOOGL", "AMZN"]
    
    func addStocks(newStockCode: String) {
        cacheStocks.append(newStockCode)
    }
    
    func removeStock(stockCode: String) {
        cacheStocks.removeAll { $0 == stockCode }
    }
    
    func fetchStockInfo(for code: String) async throws -> StockPrice? {
      return Helper.loadLocalTestDataWithoutParsing("Success", type: StockPrice.self)
    }
}
