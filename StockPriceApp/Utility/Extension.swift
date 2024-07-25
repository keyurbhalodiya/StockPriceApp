//
//  Extension.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import Foundation

extension String {
  /// Get currency symbol
  func currencySymbol() -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = self
    formatter.locale = Locale.current
    return formatter.currencySymbol
  }
}

extension Optional where Wrapped == Double {
  /// Get string value
  func stringValue() -> String {
    guard let self else { return "NA" }
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 3
    formatter.maximumFractionDigits = 3
    return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
  }
}

extension Array {
  /// Safely access array element at index
  subscript(safe index: Int) -> Element? {
    guard indices.contains(index) else {
      return nil
    }
    
    return self[index]
  }
}

extension Optional where Wrapped == Int {
  /// Get string value
  func stringValue() -> String {
    guard let self else { return "NA" }
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 3
    formatter.maximumFractionDigits = 3
    return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
  }
}
