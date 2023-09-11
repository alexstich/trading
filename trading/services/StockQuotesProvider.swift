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
    
    private var stockQuotes: [String: StockQuoteModel] = [:]
    
    func observeStockQuotes(for tickers: [String], handler: @escaping (StockQuoteModel)->Void)
    {
        self.handler = handler

        WebSocketProvider.getInstance.checkConnection()
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
            
            setStockQuotes(msg: msg)
            
            if let ticker = msg.quoteData?.c?.uppercased(), let stock = stockQuotes[ticker] {
                handler?(stock)
            }
            
        default:
            break
        }
    }
                                   
    private func setStockQuotes(msg: WebSocketMessage)
    {
        if let ticker = msg.quoteData?.c?.uppercased() {
            
            let stockQuote = StockQuoteModel(
                ticker: ticker,
                lastTradeMarketName: msg.quoteData?.ltr?.uppercased(),
                stockName: msg.quoteData?.name,
                currentPrice: msg.quoteData?.ltp,
                priceDeltaInPercent: msg.quoteData?.pcp,
                priceDelta: msg.quoteData?.chg,
                minStep: msg.quoteData?.min_step,
                stockLogo: URL(string: StockQuotesProviderConfig.shared.logoUrlString + ticker.lowercased())
            )
            
            if var currentQuote = stockQuotes[ticker] {
                
                currentQuote.merge(model: stockQuote)

                stockQuotes[ticker] = currentQuote
            } else {
                stockQuotes[ticker] = stockQuote
            }
        }
    }
}



