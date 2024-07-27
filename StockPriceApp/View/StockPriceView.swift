//
//  StockPriceView.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import SwiftUI

protocol StockPriceViewState: ObservableObject {
  var stockInfo: StockInfo? { get }
  var filterStocks: [String] { get }
}

protocol StockPriceViewListner {
  func fetchStockInfo(for code: String)
  func addStocks(newStockCode: String)
  func removeStock(stockCode: String)
  func searchStock(with code: String)
  func didCancelSearchStock()
}

typealias StockViewModel = StockPriceViewState & StockPriceViewListner

struct StockPriceView<ViewModel: StockViewModel>: View {
  
  // MARK: Dependencies
  @StateObject private var viewModel: ViewModel
  
  @State private var searchText: String = ""
  @State private var isEditing: Bool = false
  public init(viewModel: ViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationView {
      VStack {
        SearchBar(text: $searchText, isEditing: $isEditing) { searchText in
          viewModel.fetchStockInfo(for: searchText)
        }
        
        if isEditing {
          List(viewModel.filterStocks, id: \.self) { stock in
            HStack {
              Text(stock)
                .font(.system(size: 16, weight: .regular, design: .default))
              Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
              viewModel.fetchStockInfo(for: stock)
              isEditing = false
              UIApplication.shared.endEditing()
            }
          }
        } else {
          Text(viewModel.stockInfo?.stockCode ?? "")
            .font(.system(size: 18, weight: .semibold, design: .default))
          List(viewModel.stockInfo?.rowModel ?? [], id: \.self) { row in
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
      .navigationTitle("Stock")
      .onChange(of: searchText) { newValue in
        guard newValue.count > 0 else {
          viewModel.didCancelSearchStock()
          return
        }
        viewModel.searchStock(with: newValue)
      }
    }
  }
}

// MARK: Preview

#if DEBUG
private final class StockViewModelMock: StockViewModel {  
  var stockInfo: StockInfo? = StockInfo(stockCode: "9434.T", rowModel: [RowModel(title: "前日終值", value: "1942.5円"), RowModel(title: "始值", value: "1949.5円"), RowModel(title: "高值", value: "1969.5円"), RowModel(title: "安值", value: "1942.5円"), RowModel(title: "出来高", value: "5,208,000株"), RowModel(title: "52週高值", value: "1969.5円"), RowModel(title: "52週安值", value: "1942.5円")])
  var filterStocks: [String] = ["NVDA", "YMM", "FSLR", "IMMR", "GILT", "SMCI"]
  func fetchStockInfo(for code: String) { }
  func addStocks(newStockCode: String) { }
  func removeStock(stockCode: String) { }
  func searchStock(with code: String) { }
  func didCancelSearchStock() { }
}

#Preview {
  StockPriceView(viewModel: StockViewModelMock())
}

#endif
