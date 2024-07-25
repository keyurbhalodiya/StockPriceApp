//
//  DataProvider.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import Foundation

typealias DataProviding = CacheDataProviding & NetworkDataProviding

final class DataProvider: DataProviding {
  
  // MARK: Dependencies
  private let repo: CacheDataProviding
  
  init(repo: CacheDataProviding) {
    self.repo = repo
  }
}

// MARK: CacheDataProviding

extension DataProvider {
  
  var cacheStocks: [String] {
    repo.cacheStocks
  }
  
  func addStocks(newStockCode: String) {
    repo.addStocks(newStockCode: newStockCode)
  }
  
  func removeStock(stockCode: String) {
    repo.removeStock(stockCode: stockCode)
  }
}

// MARK: NetworkDataProviding

extension DataProvider {
  func fetchStockInfo(for code: String) async throws -> Chart? {
    try await NetworkService.shared.getData(stockCode: code, type: Chart.self)
  }
}
