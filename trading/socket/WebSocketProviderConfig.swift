//
//  WebSocketProviderConfig.swift
//  trading
//
//  Created by Aleksey Grebenkin on 11.09.23.
//

import Foundation

struct WebSocketProviderConfig
{
    static var shared: WebSocketProviderConfig = WebSocketProviderConfig()
    
    init() {}
    
    var wssUrlHost: URL = URL(string: "wss://wss.tradernet.ru")!
}
