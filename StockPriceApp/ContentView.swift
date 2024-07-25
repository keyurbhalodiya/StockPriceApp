//
//  ContentView.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    let dataProvider = DataProvider(repo: StockRepository())
    let viewModel = StockPriceViewModel(dataProvider: dataProvider)
    StockPriceView(viewModel: viewModel)
  }
}

#Preview {
    ContentView()
}
