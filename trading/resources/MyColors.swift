//
//  MyColors.swift
//  trading
//
//  Created by Aleksey Grebenkin on 09.09.23.
//

import Foundation
import UIKit

enum MyColors: String
{
    case percentage_red
    case percentage_green
    
    case white
    
    func getUIColor() -> UIColor
    {
        guard let color = UIColor(named: self.rawValue) else {
            fatalError("**** Error cant create Font ****")
        }
        
        return color
    }
    
    func getCGColor() -> CGColor
    {
        guard let color = UIColor(named: self.rawValue)?.cgColor else {
            fatalError("**** Error cant create Font ****")
        }
        
        return color
    }
}
