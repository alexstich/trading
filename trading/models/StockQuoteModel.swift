//
//  StockQuoteModel.swift
//  trading
//
//  Created by Aleksey Grebenkin on 09.09.23.
//

import Foundation
import UIKit

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
