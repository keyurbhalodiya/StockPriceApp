//
//  StockPriceViewModel.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import Foundation

protocol CacheDataProviding {
  var cacheStocks: [String] { get }
  func addStocks(newStockCode: String)
  func removeStock(stockCode: String)
}

protocol NetworkDataProviding {
  func fetchStockInfo(for code: String) async throws -> StockPrice?
}

final class StockPriceViewModel: StockViewModel {
  
  // MARK: Dependencies
  private let dataProvider: DataProviding
  
  @Published private(set) var rowModel: [RowModel] = []
  @Published private(set) var cacheStocks: [String] = []

  init(dataProvider: DataProviding) {
    self.dataProvider = dataProvider
  }
  
  func fetchStockInfo(for code: String) {
    Task {
        do {
          let stockInfo = try await dataProvider.fetchStockInfo(for: code)
          self.generateRowModel(with: stockInfo?.chart?.result?.first)
        } catch {
            print("Request failed with error: \(error)")
        }
    }
  }
  
  func addStocks(newStockCode: String) {
    dataProvider.addStocks(newStockCode: newStockCode)
  }
  
  func removeStock(stockCode: String) {
    dataProvider.removeStock(stockCode: stockCode)
  }
}

private extension StockPriceViewModel {
  
  func getCacheData() {
    self.cacheStocks = dataProvider.cacheStocks
  }
  
  func generateRowModel(with result: Result?) {
    guard let result else { return }
    let currenctSymbol = result.meta?.currency?.currencySymbol() ?? ""
    var tempRowModel: [RowModel] = []
    tempRowModel.append(RowModel(title: Constant.lastDayValue, value: (result.meta?.previousClose.stringValue() ?? "") + currenctSymbol))
    tempRowModel.append(RowModel(title: Constant.initialValue, value: (result.indicators?.quote?[safe: 0]?.quoteOpen?[safe: 0]?.stringValue() ?? "") + currenctSymbol))
    tempRowModel.append(RowModel(title: Constant.highValue, value: (result.meta?.regularMarketDayHigh.stringValue() ?? "") + currenctSymbol))
    tempRowModel.append(RowModel(title: Constant.lowValue, value: (result.meta?.regularMarketDayLow.stringValue() ?? "") + currenctSymbol))
    tempRowModel.append(RowModel(title: Constant.turnover, value: (result.meta?.regularMarketVolume.stringValue() ?? "") + "株"))
    tempRowModel.append(RowModel(title: Constant.fiftyTwoWeekHigh, value: (result.meta?.fiftyTwoWeekHigh.stringValue() ?? "") + currenctSymbol))
    tempRowModel.append(RowModel(title: Constant.fiftyTwoWeekLow, value: (result.meta?.fiftyTwoWeekLow.stringValue() ?? "") + currenctSymbol))
    self.rowModel = tempRowModel
  }
  
}
