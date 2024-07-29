//
//  StockDetailView.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/29.
//

import SwiftUI

struct StockDetailView: View {
  var stockInfo: StockInfo?
  var stockChart: [StockChart]?
  
  var body: some View {
    Text(stockInfo?.stockCode ?? "")
      .font(.system(size: 18, weight: .semibold, design: .default))
    
    VStack {
      if let rowModel = stockInfo?.rowModel {
        ForEach(rowModel, id: \.self) { row in
          HStack {
            Text(row.title)
              .foregroundStyle(.secondary)
              .font(.system(size: 16, weight: .medium, design: .default))
            Spacer()
            Text(row.value)
              .font(.system(size: 16, weight: .semibold, design: .default))
          }
          Spacer()
        }
        Spacer()
        HStack {
          LineChartView(stockChart: stockChart)
        }
      } else {
        Spacer()
        Text("Enter stock code")
          .foregroundStyle(.secondary)
          .font(.system(size: 28, weight: .regular, design: .default))
        Spacer()
      }
    }
    .padding(16)
  }
}
