//
//  StockPriceView.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import SwiftUI

protocol StockPriceViewState: ObservableObject {
  var rowModel: [String: Any] { get }
  var cacheStocks: [String] { get }
}

protocol StockPriceViewListner {
  func fetchStockInfo(for code: String)
  func addStocks(newStockCode: String)
  func removeStock(stockCode: String)
}

typealias StockViewModel = StockPriceViewState & StockPriceViewListner

struct StockPriceView<ViewModel: StockViewModel>: View {
  
  // MARK: Dependencies
  @StateObject private var viewModel: ViewModel
  
  public init(viewModel: ViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

// MARK: Preview

#if DEBUG
private final class StockViewModelMock: StockViewModel {
  var rowModel: [String : Any] = ["前日終值" : "1942.5円", "始值" : "1949.5F1", "高值" : "1969.5円", "安值" : "1942.581", "出来高" : "5,208,000株", "52週高值" : "1969.5円", "52週安值" : "1942.5円"]
  var cacheStocks: [String] = ["NVDA", "YMM", "FSLR", "IMMR", "GILT", "SMCI"]
  func fetchStockInfo(for code: String) { }
  func addStocks(newStockCode: String) { }
  func removeStock(stockCode: String) { }
}

#Preview {
  StockPriceView(viewModel: StockViewModelMock())
}

#endif

