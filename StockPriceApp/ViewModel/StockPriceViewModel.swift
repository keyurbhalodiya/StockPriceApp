//
//  StockPriceViewModel.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import Combine

protocol CacheDataProviding {
  var cacheStocks: [String] { get }
  func addStocks(newStockCode: String)
  func removeStock(stockCode: String)
}

protocol NetworkDataProviding {
  func fetchStockInfo(for code: String) async throws -> Chart?
}

final class StockPriceViewModel {
  
}
