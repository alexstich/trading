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
    
    private var handler: ((StockQuoteModel)->Void)?
    
    func observeStockQuotes(for tickers: [String], handler: @escaping (StockQuoteModel)->Void)
    {
        self.handler = handler
        
        // Mock data
        if Constants.test_mode {
            let quote = StockQuoteModel(
                ticker: "SBER",
                lastTradeMarketName: "MTX",
                stockName: "Сбербанк",
                currentPrice: 1235231.5544,
                priceDeltaInPercent: 30.25,
                priceDelta: -0.00043,
                minStep: 0.0001
            )
            
            self.handler?(quote)
        }
        
        WebSocketProvider.getInstance.establishConnection()
        WebSocketProvider.getInstance.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            do {
                try WebSocketProvider.getInstance.send(type: .quotes, data: tickers)
            } catch {
                print("**** websocket sending error occure")
            }
        }
    }
}

extension StockQuotesProvider: WebSocketProviderDelegate
{
    func webSocketDidConnect(_ webSocket: WebSocketProvider)
    {
        print("**** websocket call delegate server connected")
    }
    
    func webSocketDidDisconnect(_ webSocket: WebSocketProvider)
    {
        print("**** websocket call delegate server disconnected")
    }
    
    func webSocket(_ webSocket: WebSocketProvider, didReceiveMessage msg: WebSocketMessage)
    {
        let type = SocketMessageType(rawValue: msg.type)
        
        switch type {
        case .q:
            let stockModel = StockQuoteModel(
                ticker: msg.quoteData?.c?.uppercased() ?? "",
                lastTradeMarketName: msg.quoteData?.ltr?.uppercased() ?? "",
                stockName: msg.quoteData?.name ?? "",
                currentPrice: msg.quoteData?.ltp ?? 0,
                priceDeltaInPercent: msg.quoteData?.pcp ?? 0,
                priceDelta: msg.quoteData?.chg ?? 0,
                minStep: msg.quoteData?.min_step ?? 0.01
            )
            
            handler?(stockModel)
        default:
            break
        }
    }
}



