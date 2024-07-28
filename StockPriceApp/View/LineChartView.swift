//
//  LineChartView.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/28.
//

import SwiftUI
import Charts

struct LineChartView: View {
  var stockChart: [StockChart]?
  
  var body: some View {
      Chart {
        ForEach(stockChart ?? [], id: \.self) { chart in
              LineMark(
                x: .value("Time", Date(timeIntervalSince1970: chart.timestamp)),
                y: .value("Price", chart.close)
              )
          }
      }
      .chartYScale(domain: [stockChart?.min(by: { $0.close < $1.close })?.close ?? 0, stockChart?.max(by: { $0.close < $1.close })?.close ?? 0])

      .chartXAxisLabel("Time")
      .chartYAxisLabel("Price")
    
      .chartXAxis {
          AxisMarks(preset: .aligned, position: .bottom, values: .automatic) { value in
            if value.as(Date.self) != nil {
                  AxisValueLabel(format: Date.FormatStyle().hour().minute())
              }
          }
      }
  }
}


#Preview {
    LineChartView(stockChart: [StockChart(timestamp: 1, close: 1720),
                               StockChart(timestamp: 2, close: 1820),
                               StockChart(timestamp: 3, close: 1645)])
}

