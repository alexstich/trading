//
//  DateManager.swift
//  trading
//
//  Created by Aleksey Grebenkin on 09.09.23.
//

import Foundation

class DateManager
{
    static let FORMAT_LONG = "yyyy-MM-dd HH:mm:ss"
    static let FORMAT_SHORT = "yyyy-MM-dd"
    static let ALL_FORMATS = [FORMAT_LONG, FORMAT_SHORT]
    
    static func dateFromString(from string: String, format: String = DateManager.FORMAT_LONG) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: string) {
            return date
        }
        
        for i in 0..<DateManager.ALL_FORMATS.count {
            let format = DateManager.ALL_FORMATS[i]
            dateFormatter.dateFormat = format
            
            if let date = dateFormatter.date(from: string) {
                return date
            }
        }
        
        return nil
    }
}
