//
//  StockPriceView.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import SwiftUI

protocol StockPriceViewState: ObservableObject {
  var rowModel: [RowModel] { get }
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
    VStack {
      List(viewModel.rowModel, id: \.self) { row in
        HStack {
          Text(row.title)
            .foregroundStyle(.secondary)
            .font(.system(size: 16, weight: .medium, design: .default))
          Spacer()
          Text(row.value)
            .font(.system(size: 16, weight: .semibold, design: .default))
        }
      }
    }
  }
}

// MARK: Preview

#if DEBUG
private final class StockViewModelMock: StockViewModel {  
  var rowModel: [RowModel] = [RowModel(title: "前日終值", value: "1942.5円"), RowModel(title: "始值", value: "1949.5円"), RowModel(title: "高值", value: "1969.5円"), RowModel(title: "安值", value: "1942.5円"), RowModel(title: "出来高", value: "5,208,000株"), RowModel(title: "52週高值", value: "1969.5円"), RowModel(title: "52週安值", value: "1942.5円")]
  var cacheStocks: [String] = ["NVDA", "YMM", "FSLR", "IMMR", "GILT", "SMCI"]
  func fetchStockInfo(for code: String) { }
  func addStocks(newStockCode: String) { }
  func removeStock(stockCode: String) { }
}

#Preview {
  StockPriceView(viewModel: StockViewModelMock())
}

#endif

