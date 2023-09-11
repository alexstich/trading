//
//  AppDelegate.swift
//  trading
//
//  Created by Aleksey Grebenkin on 08.09.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        WebSocketProviderConfig.shared.wssUrlHost = URL(string: "wss://wss.tradernet.ru")!
        StockQuotesProviderConfig.shared.logoUrlString = "https://tradernet.ru/logos/get-logo-by-ticker?ticker="
        
        return true
    }
}

