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
    var stockLogo: UIImage?
    var currentPrice: Double
    var priceDeltaInPercent: Double
    var priceDelta: Double
    
    init(
        ticker: String,
        lastTradeMarketName: String,
        stockLogo: UIImage?,
        stockName: String,
        currentPrice: Double,
        priceDeltaInPercent: Double,
        priceDelta: Double
    )
    {
        self.ticker = ticker
        self.lastTradeMarketName = lastTradeMarketName
        self.stockName = stockName
        self.stockLogo = stockLogo
        self.currentPrice = currentPrice
        self.priceDelta = priceDelta
        self.priceDeltaInPercent = priceDeltaInPercent
    }
    
    func percentageDeltaIsPositive() -> Bool
    {
        return priceDeltaInPercent > 0
    }
}
