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
  func fetchStockInfo(for code: String) async throws -> Chart?
}

final class StockPriceViewModel: StockViewModel {
  
  // MARK: Dependencies
  private let dataProvider: DataProviding
  
  @Published private(set) var rowModel: [String: String] = [:]
  @Published private(set) var cacheStocks: [String] = []

  init(dataProvider: DataProviding) {
    self.dataProvider = dataProvider
  }
  
  func fetchStockInfo(for code: String) {
    Task {
        do {
          let stockInfo = try await dataProvider.fetchStockInfo(for: code)
          self.generateRowModel(with: stockInfo?.result?.first)
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
    var tempRowModel: [String: String] = [:]
    tempRowModel[Constant.lastDayValue] = (result.meta?.previousClose.stringValue() ?? "") + currenctSymbol
    tempRowModel[Constant.initialValue] = (result.indicators?.quote?[safe: 0]?.quoteOpen?[safe: 0]?.stringValue() ?? "") + currenctSymbol
    tempRowModel[Constant.highValue] = (result.meta?.regularMarketDayHigh.stringValue() ?? "") + currenctSymbol
    tempRowModel[Constant.lowValue] = (result.meta?.regularMarketDayLow.stringValue() ?? "") + currenctSymbol
    tempRowModel[Constant.turnover] = (result.meta?.regularMarketVolume.stringValue() ?? "") + "株"
    tempRowModel[Constant.fiftyTwoWeekHigh] = (result.meta?.fiftyTwoWeekHigh.stringValue() ?? "") + currenctSymbol
    tempRowModel[Constant.fiftyTwoWeekLow] = (result.meta?.fiftyTwoWeekLow.stringValue() ?? "") + currenctSymbol
    self.rowModel = tempRowModel
  }
  
}
