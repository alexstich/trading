//
//  StockQuotesListViewModel.swift
//  trading
//
//  Created by Aleksey Grebenkin on 10.09.23.
//

import Foundation
import RxSwift

protocol StockQuotesListViewModelProtocol: AnyObject
{
    var stockQuotes: BehaviorSubject<[StockQuoteModel]> { get }
}

class StockQuotesListViewModel: StockQuotesListViewModelProtocol
{
    let availableStockTickers: [String] = [
        "RSTI",
        "GAZP",
        "MRKZ",
        "RUAL",
        "HYDR",
        "MRKS",
        "SBER",
        "FEES",
        "TGKA",
        "VTBR",
        "ANH.US",
        "VICL.US",
        "BURG.US",
        "NBL.US",
        "YETI.US",
        "WSFS.US",
        "NIO.US",
        "DXC.US",
        "MIC.US",
        "HSBC.US",
        "EXPN.EU",
        "GSK.EU",
        "SHP.EU",
        "MAN.EU",
        "DB1.EU",
        "MUV2.EU",
        "TATE.EU",
        "KGF.EU",
        "MGGT.EU",
        "SGGD.EU",
    ]
    
    var stockQuotes: BehaviorSubject<[StockQuoteModel]> = BehaviorSubject(value: [StockQuoteModel]())
    
    init()
    {
        StockQuotesProvider.instance.observeStockQuotes(for: availableStockTickers) { [weak self] stockQuote in
            
            guard let self = self else { return }
            
            let queue = DispatchQueue(label: "stock_provider.serialqueue", qos:.userInteractive)
            queue.async { [weak self] in
                if let newStockQuotes = self?.insertStockQuote(stockQuote: stockQuote) {
                    DispatchQueue.main.async { [weak self] in
                        self?.stockQuotes.onNext(newStockQuotes)
                    }
                }
            }
        }
    }
    
    private func insertStockQuote(stockQuote: StockQuoteModel) -> [StockQuoteModel]
    {
        var stockQuotesArray = (try? self.stockQuotes.value()) ?? []
        
        var wasReplaced = false
        for (index, quote) in stockQuotesArray.enumerated() {
            if quote.ticker == stockQuote.ticker {
                stockQuotesArray[index] = quote
                wasReplaced = true
                break
            }
        }
        
        if !wasReplaced {
            stockQuotesArray.append(stockQuote)
        }
        
        return stockQuotesArray
    }
}


