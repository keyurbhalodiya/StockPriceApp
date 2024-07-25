//
//  StockRepository.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import Foundation

final class StockRepository: CacheDataProviding {

  private enum Constant {
    static let cacheStocksCodeKey: String = "cacheStocksCodeKey"
  }
  
  static let shared = StockRepository()
  private let userDefault = UserDefaults.standard
  
  private init() { }
  
  private func updateCache(shouldAdd: Bool = true, stockCode: String) {
    var cacheData = cacheStocks
    if shouldAdd {
      cacheData.append(stockCode)
    } else {
      cacheData.removeAll { code in
        code == stockCode
      }
    }
    userDefault.setValue(cacheData, forKey: Constant.cacheStocksCodeKey)
  }
}

// MARK: CacheDataProviding

extension StockRepository {
  
  var cacheStocks: [String] {
    guard let cacheData = userDefault.object(forKey: Constant.cacheStocksCodeKey) as? [String] else {
      return []
    }
    return cacheData
  }
  
  func addStocks(newStockCode: String) {
    updateCache(stockCode: newStockCode)
  }
  
  func removeStock(stockCode: String) {
    updateCache(shouldAdd: false, stockCode: stockCode)
  }
}
