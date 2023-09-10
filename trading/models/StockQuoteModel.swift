//
//  StockQuoteModel.swift
//  trading
//
//  Created by Aleksey Grebenkin on 09.09.23.
//

import Foundation
import UIKit
import DeepDiff

class StockQuoteModel
{
    var ticker: String
    var lastTradeMarketName: String
    var stockName: String
    var stockLogo: URL?
    var currentPrice: Double
    var priceDeltaInPercent: Double
    var priceDelta: Double
    var minStep: Double = 0.01
    
    init(
        ticker: String,
        lastTradeMarketName: String,
        stockName: String,
        currentPrice: Double,
        priceDeltaInPercent: Double,
        priceDelta: Double,
        minStep: Double
    )
    {
        self.ticker = ticker
        self.lastTradeMarketName = lastTradeMarketName
        self.stockName = stockName
        self.currentPrice = currentPrice
        self.priceDelta = priceDelta
        self.priceDeltaInPercent = priceDeltaInPercent
        self.minStep = minStep
        self.stockLogo = URL(string: "https://tradernet.ru/logos/get-logo-by-ticker?ticker=" + self.ticker.lowercased())
    }
    
    func percentageDeltaIsPositive() -> Bool
    {
        return priceDeltaInPercent > 0
    }
}

extension StockQuoteModel: DiffAware
{
    var diffId: String
    {
        return ticker
    }
    
    static func compareContent(_ a: StockQuoteModel, _ b: StockQuoteModel) -> Bool
    {
        return a.ticker == b.ticker && a.currentPrice == b.currentPrice
    }
}
