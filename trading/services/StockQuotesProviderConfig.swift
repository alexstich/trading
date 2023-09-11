//
//  StockQuotesProviderConfig.swift
//  trading
//
//  Created by Aleksey Grebenkin on 11.09.23.
//

import Foundation

struct StockQuotesProviderConfig
{
    static var shared: StockQuotesProviderConfig = StockQuotesProviderConfig()
    
    init() {}
    
    var logoUrlString: String = "https://tradernet.ru/logos/get-logo-by-ticker?ticker="
}
