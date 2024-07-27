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
  
  private var cacheStocks: [String]
  @Published private(set) var stockInfo: StockInfo?
  @Published private(set) var filterStocks: [String] = []

  init(dataProvider: DataProviding) {
    self.dataProvider = dataProvider
    self.cacheStocks = dataProvider.cacheStocks
    self.filterStocks = self.cacheStocks
  }
  
  func fetchStockInfo(for code: String) {
    stockInfo = nil
    Task {
        do {
          let stockInfo = try await dataProvider.fetchStockInfo(for: code)
          guard let results = stockInfo?.chart?.result, let result = results[safe: 0] else { return }
          self.generateRowModel(with: result)
          self.addStocks(newStockCode: code)
        } catch {
            print("Request failed with error: \(error)")
        }
    }
  }
  
  func addStocks(newStockCode: String) {
    dataProvider.addStocks(newStockCode: newStockCode)
    guard !cacheStocks.contains(where: { $0 == newStockCode }) else { return }
    cacheStocks.append(newStockCode)
    filterStocks.append(newStockCode)
  }
  
  func removeStock(stockCode: String) {
    dataProvider.removeStock(stockCode: stockCode)
  }
  
  func searchStock(with code: String) {
    filterStocks = cacheStocks.filter({ $0.localizedCaseInsensitiveContains(code) })
  }
  
  func didCancelSearchStock() {
    filterStocks = cacheStocks
  }
}

private extension StockPriceViewModel {
  
  func generateRowModel(with result: Result) {
    let currenctSymbol = result.meta?.currency?.currencySymbol() ?? ""
    var tempRowModel: [RowModel] = []
    tempRowModel.append(RowModel(title: Constant.lastDayValue, value: (result.meta?.previousClose.stringValue() ?? "") + currenctSymbol))
    tempRowModel.append(RowModel(title: Constant.initialValue, value: (result.indicators?.quote?[safe: 0]?.quoteOpen?[safe: 0]?.stringValue() ?? "") + currenctSymbol))
    tempRowModel.append(RowModel(title: Constant.highValue, value: (result.meta?.regularMarketDayHigh.stringValue() ?? "") + currenctSymbol))
    tempRowModel.append(RowModel(title: Constant.lowValue, value: (result.meta?.regularMarketDayLow.stringValue() ?? "") + currenctSymbol))
    tempRowModel.append(RowModel(title: Constant.turnover, value: (result.meta?.regularMarketVolume.stringValue() ?? "") + "株"))
    tempRowModel.append(RowModel(title: Constant.fiftyTwoWeekHigh, value: (result.meta?.fiftyTwoWeekHigh.stringValue() ?? "") + currenctSymbol))
    tempRowModel.append(RowModel(title: Constant.fiftyTwoWeekLow, value: (result.meta?.fiftyTwoWeekLow.stringValue() ?? "") + currenctSymbol))
    DispatchQueue.main.async { [unowned self] in
      self.stockInfo = StockInfo(stockCode: result.meta?.symbol ?? "", rowModel: tempRowModel)
    }
  }
}
