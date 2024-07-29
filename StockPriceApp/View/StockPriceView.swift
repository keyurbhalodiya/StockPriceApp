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
  var stockChart: [StockChart]? { get }
  var isLoading: Bool { get }
  var showingAlert: Bool { get set }
}

protocol StockPriceViewListner {
  func fetchStockInfo(for code: String)
  func removeStock(stockCode: String)
  func searchStock(with code: String)
  func didCancelSearchStock()
}

typealias StockViewModel = StockPriceViewState & StockPriceViewListner

struct StockPriceView<ViewModel: StockViewModel>: View {
  
  // MARK: Dependencies
  @StateObject private var viewModel: ViewModel
  
  @Environment(\.isLoading) private var isLoading

  @State private var searchText: String = ""
  @State private var isEditing: Bool = false
  @State private var showingAlert: Bool = false
  
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
          FilteredStocksListView(viewModel: viewModel, isEditing: $isEditing)
        } else {
          StockDetailView(stockInfo: viewModel.stockInfo, stockChart: viewModel.stockChart, isLoading: viewModel.isLoading)
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
    .onChange(of: viewModel.isLoading) { newValue in
        isLoading.wrappedValue = newValue
    }
    .onChange(of: viewModel.showingAlert) { newValue in
      $showingAlert.wrappedValue = newValue
    }
    .alert("Somthing went wrong", isPresented: $showingAlert) {
        Button("OK", role: .cancel) { 
          viewModel.showingAlert = false
        }
    } message: {
        Text("No data found, symbol may be delisted")
    }
  }
}

// MARK: Preview

#if DEBUG
private final class StockViewModelMock: StockViewModel {
  var stockInfo: StockInfo? = StockInfo(stockCode: "9434.T", rowModel: [RowModel(title: "前日終值", value: "1942.5円"), RowModel(title: "始值", value: "1949.5円"), RowModel(title: "高值", value: "1969.5円"), RowModel(title: "安值", value: "1942.5円"), RowModel(title: "出来高", value: "5,208,000株"), RowModel(title: "52週高值", value: "1969.5円"), RowModel(title: "52週安值", value: "1942.5円")])
  var filterStocks: [String] = ["NVDA", "YMM", "FSLR", "IMMR", "GILT", "SMCI"]
  var stockChart: [StockChart]? = [StockChart(timestamp: 1, close: 1020), StockChart(timestamp: 2, close: 1820), StockChart(timestamp: 3, close: 1345)]
  var isLoading: Bool = true
  var showingAlert: Bool = false

  func fetchStockInfo(for code: String) { }
  func removeStock(stockCode: String) { }
  func searchStock(with code: String) { }
  func didCancelSearchStock() { }
}

#Preview {
  StockPriceView(viewModel: StockViewModelMock())
}

#endif
