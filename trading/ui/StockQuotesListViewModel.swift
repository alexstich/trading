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
    var stockQuotes: BehaviorSubject<String?> { get }
}

class StockQuotesListViewModel
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
    
    let stockQuotes: BehaviorSubject<[StockQuoteModel]> = BehaviorSubject(value: [StockQuoteModel]())
    
    init()
    {
        StockQuotesProvider.instance.observeStockQuotes(for: availableStockTickers) { [weak self] stockQuote in
            self?.stockQuotes.onNext([stockQuote])
        }
    }
}


