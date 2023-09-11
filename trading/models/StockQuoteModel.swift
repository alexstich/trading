//
//  StockQuoteModel.swift
//  trading
//
//  Created by Aleksey Grebenkin on 09.09.23.
//

import Foundation
import UIKit
import DeepDiff

struct StockQuoteModel
{
    enum Trend: String {
        case positive, negative, none
    }
    var ticker: String
    var lastTradeMarketName: String?
    var stockName: String?
    var stockLogo: URL?
    var currentPrice: Double?
    var priceDeltaInPercent: Double?
    var priceDelta: Double?
    var minStep: Double?
    var trend: Trend = .none
    
    init(
        ticker: String,
        lastTradeMarketName: String?,
        stockName: String?,
        currentPrice: Double?,
        priceDeltaInPercent: Double?,
        priceDelta: Double?,
        minStep: Double?,
        stockLogo: URL? = nil
    )
    {
        self.ticker = ticker
        self.lastTradeMarketName = lastTradeMarketName
        self.stockName = stockName
        self.currentPrice = currentPrice
        self.priceDelta = priceDelta
        self.priceDeltaInPercent = priceDeltaInPercent
        self.minStep = minStep
        self.stockLogo = stockLogo
        self.trend = .none
    }
    
    mutating func merge(model: StockQuoteModel)
    {
        if model.currentPrice != nil {
            
            if (self.currentPrice! - model.currentPrice!) > 0 {
                self.trend = .positive
            } else if (self.currentPrice! - model.currentPrice!) < 0 {
                self.trend = .negative
            } else {
                self.trend = .none
            }

            self.currentPrice = model.currentPrice
        } else {
            self.trend = .none
        }
        if model.lastTradeMarketName != nil {
            self.lastTradeMarketName = model.lastTradeMarketName
        }
        if model.stockName != nil {
            self.stockName = model.stockName
        }
        if model.priceDelta != nil {
            self.priceDelta = model.priceDelta
        }
        if model.priceDeltaInPercent != nil {
            self.priceDeltaInPercent = model.priceDeltaInPercent
        }
        if model.minStep != nil {
            self.minStep = model.minStep
        }
        if model.stockLogo != nil {
            self.stockLogo = model.stockLogo
        }
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
        return a.currentPrice == b.currentPrice && a.priceDelta == b.priceDelta && a.priceDeltaInPercent == b.priceDeltaInPercent
    }
}
