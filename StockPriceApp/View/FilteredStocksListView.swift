//
//  FilteredStocksListView.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/29.
//

import SwiftUI

struct FilteredStocksListView<ViewModel: StockViewModel>: View {
  @ObservedObject var viewModel: ViewModel
  @Binding var isEditing: Bool
  
  var body: some View {
    
    List {
      ForEach(viewModel.filterStocks, id: \.self) { stock in
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
      .onDelete { indexSet in
        for i in indexSet.makeIterator() {
          guard let stock = viewModel.filterStocks[safe: i] else { return }
          viewModel.removeStock(stockCode: stock)
        }
      }
    }
  }
}
