//
//  Model.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/25.
//

import Foundation

// MARK: - StockPrice
struct StockPrice: Codable {
    let chart: Chart?
}

// MARK: - Chart
struct Chart: Codable {
    let result: [Result]?
    let error: StockPriceError?
}

// MARK: - Result
struct Result: Codable {
    let meta: Meta?
    let timestamp: [Int]?
    let indicators: Indicators?
}

// MARK: - Indicators
struct Indicators: Codable {
    let quote: [Quote]?
}

// MARK: - Quote
struct Quote: Codable {
    let low, close: [Double?]?
    let volume: [Int?]?
    let quoteOpen, high: [Double?]?

    enum CodingKeys: String, CodingKey {
        case low, close, volume
        case quoteOpen = "open"
        case high
    }
}

// MARK: - Meta
struct Meta: Codable {
    let currency, symbol, exchangeName, fullExchangeName: String?
    let instrumentType: String?
    let firstTradeDate, regularMarketTime: Int?
    let hasPrePostMarketData: Bool?
    let gmtoffset: Int?
    let timezone, exchangeTimezoneName: String?
    let regularMarketPrice, fiftyTwoWeekHigh: Int?
    let fiftyTwoWeekLow: Double?
    let regularMarketDayHigh: Int?
    let regularMarketDayLow: Double?
    let regularMarketVolume, chartPreviousClose, previousClose, scale: Int?
    let priceHint: Int?
    let currentTradingPeriod: CurrentTradingPeriod?
    let tradingPeriods: [[Post]]?
    let dataGranularity, range: String?
    let validRanges: [String]?
}

// MARK: - CurrentTradingPeriod
struct CurrentTradingPeriod: Codable {
    let pre, regular, post: Post?
}

// MARK: - Post
struct Post: Codable {
    let timezone: String?
    let end, start, gmtoffset: Int?
}

// MARK: - StockPriceError
struct StockPriceError: Codable {
    let code, description: String?
}
