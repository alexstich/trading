//
//  ExtDouble.swift
//  trading
//
//  Created by Aleksey Grebenkin on 09.09.23.
//

import Foundation

extension Double
{
    func formatToString(minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2, showAlwaysSign: Bool = true, separeteByGroups: Bool = true) -> String
    {
        let formatter = NumberFormatter()
        
        if showAlwaysSign {
            formatter.plusSign = "+"
            formatter.minusSign = "-"
            formatter.positivePrefix = "+"
            formatter.negativePrefix = "-"
        }
        
        if separeteByGroups {
            formatter.groupingSeparator = " "
            formatter.usesGroupingSeparator = true
            formatter.groupingSize = 3
            formatter.secondaryGroupingSize = 3
        }
        
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits

        return formatter.string(from: self as NSNumber)!
    }
    
    func numberOfDigitsInIntegerPart() -> Int?
    {
        guard self.isFinite else {
            return nil
        }
        
        let integerPart = Int(self)
        return String(abs(integerPart)).count
    }
    
    func numberOfDigitsAfterComma() -> Int
    {
        let numberString = String(self)
        let components = numberString.split(separator: ".")
        
        guard components.count == 2 else {
            return 0
        }
        
        return components[1].count
    }
}
