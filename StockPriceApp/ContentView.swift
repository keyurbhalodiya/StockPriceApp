//
//  ContentView.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import SwiftUI

struct ContentView: View {
  
  @State private var isLoading: Bool = false

  var body: some View {
    let dataProvider = DataProvider(repo: StockRepository())
    let viewModel = StockPriceViewModel(dataProvider: dataProvider)
    StockPriceView(viewModel: viewModel)
      .environment(\.isLoading, $isLoading)
      .hudOverlay(isLoading)
  }
}

struct LoadingEnvironmentKey: EnvironmentKey {
    public static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isLoading: Binding<Bool> {
        get {
            self [LoadingEnvironmentKey.self]
        }
        set {
            self [LoadingEnvironmentKey.self] = newValue
        }
    }
}

#Preview {
    ContentView()
}
