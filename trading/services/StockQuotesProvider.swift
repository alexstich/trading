//
//  StockQuotesProvider.swift
//  trading
//
//  Created by Aleksey Grebenkin on 10.09.23.
//

import Foundation
import UIKit

class StockQuotesProvider
{
    static let instance: StockQuotesProvider = StockQuotesProvider()
    
    private init(){}
    
    func observeStockQuotes(for tickers: [String], onNext: (StockQuoteModel)->Void)
    {
        // Mock data
        if Constants.test_mode {
            let quote = StockQuoteModel(
                ticker: "SBER",
                lastTradeMarketName: "MTX",
                stockLogo: UIImage(systemName: "square.and.arrow.up.circle"),
                stockName: "Сбербанк",
                currentPrice: 1235231.5544562,
                priceDeltaInPercent: 30.25,
                priceDelta: -0.000054
            )
            
            onNext(quote)
        }
    }
}


