//
//  NetworkService.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case responseError
  case unknown
}

final class NetworkService {
  
  private enum Constant {
    static let baseUrl = "https://query1.finance.yahoo.com/v8/finance/chart/"
  }
  
  static let shared = NetworkService()
  
  private init() { }
  
  func getData<T: Decodable>(stockCode: String, type: T.Type) async throws -> T {
    guard let url = URL(string: "\(Constant.baseUrl)\(stockCode)") else {
        throw NetworkError.invalidURL
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    // Parse the JSON data
    let result = try JSONDecoder().decode(T.self, from: data)
    return result
  }
}

