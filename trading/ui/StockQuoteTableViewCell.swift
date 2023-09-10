//
//  StockQuoteTableViewCell.swift
//  trading
//
//  Created by Aleksey Grebenkin on 09.09.23.
//

import Foundation
import UIKit


class StockQuoteTableViewCell: UITableViewCell
{
    static var reuseId: String = "StockQuoteCell"
    
    @IBOutlet weak var TickerLabel: Label!
    @IBOutlet weak var PriceDeltaInPercentLabel: Label!
    @IBOutlet weak var MarketAndStockNameLabel: Label!
    @IBOutlet weak var StockLogoImageView: UIImageView!
    @IBOutlet weak var PriceDeltaLabel: Label!
    @IBOutlet weak var PriceLabel: Label!
    
    static var priceDeltaInPercentMaxDigitsAfterComma: Int = 2
    
    static var priceMaxDigitsAfterComma: Int = 6
    static var priceMinDigitsAfterComma = 2
    
    static var priceDeltaMaxDigitsAfterComma: Int = 6
    static var priceDeltaMinDigitsAfterComma = 2
    
    var quote: StockQuoteModel!
    var timer: Timer?
    var timeInterval: Double = 2
    
    override func prepareForReuse()
    {
        quote = nil
        
        TickerLabel.text = nil
        PriceDeltaInPercentLabel.text = nil
        MarketAndStockNameLabel.text = nil
        StockLogoImageView.image = nil
        PriceDeltaLabel.text = nil
        PriceLabel.text = nil
        
        timer?.invalidate()
        timer = nil
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        PriceDeltaInPercentLabel.layer.cornerRadius = 7
        PriceDeltaInPercentLabel.clipsToBounds = true
        PriceDeltaInPercentLabel.leftInset = 3
        PriceDeltaInPercentLabel.rightInset = 3
        PriceDeltaInPercentLabel.topInset = 0
        PriceDeltaInPercentLabel.bottomInset = 0
        
        TickerLabel.leftInset = 10
        
        PriceLabel.rightInset = 5
    }
    
    func bindData(quote: StockQuoteModel)
    {
        self.quote = quote
        
        setDeltaPriceInPercentage()
        
        TickerLabel.text = quote.ticker.uppercased()
        MarketAndStockNameLabel.text = quote.lastTradeMarketName.uppercased() + " | " + quote.stockName
        
        setPriceLabel()
        setDeltaPriceLabel()
        
        StockLogoImageView.image = quote.stockLogo
    }
    
    private func setPriceLabel()
    {
        var numberOfDigitsAfterComma = StockQuoteTableViewCell.priceMaxDigitsAfterComma
        
        if let numberOfDigitsInIntegerPart = quote.currentPrice.numberOfDigitsInIntegerPart() {
            numberOfDigitsAfterComma = StockQuoteTableViewCell.priceMaxDigitsAfterComma - numberOfDigitsInIntegerPart
            numberOfDigitsAfterComma = (numberOfDigitsAfterComma < StockQuoteTableViewCell.priceMinDigitsAfterComma) ? StockQuoteTableViewCell.priceMinDigitsAfterComma : numberOfDigitsAfterComma
        }
        
        PriceLabel.text = quote.currentPrice.formatToString(
            minimumFractionDigits: StockQuoteTableViewCell.priceMinDigitsAfterComma,
            maximumFractionDigits: numberOfDigitsAfterComma
        )
    }
    
    private func setDeltaPriceLabel()
    {
        var numberOfDigitsAfterComma = StockQuoteTableViewCell.priceDeltaMaxDigitsAfterComma
        
        if let numberOfDigitsInIntegerPart = quote.priceDelta.numberOfDigitsInIntegerPart() {
            numberOfDigitsAfterComma = StockQuoteTableViewCell.priceDeltaMaxDigitsAfterComma - numberOfDigitsInIntegerPart
            numberOfDigitsAfterComma = (numberOfDigitsAfterComma < StockQuoteTableViewCell.priceDeltaMinDigitsAfterComma) ? StockQuoteTableViewCell.priceDeltaMinDigitsAfterComma : numberOfDigitsAfterComma
        }

        PriceDeltaLabel.text =
            "( " +
            quote.priceDelta.formatToString(
                minimumFractionDigits: StockQuoteTableViewCell.priceDeltaMinDigitsAfterComma,
                maximumFractionDigits: numberOfDigitsAfterComma
            ) +
            " )"
    }
    
    private func setDeltaPriceInPercentage()
    {
        showBackground()
    
        PriceDeltaInPercentLabel.text = quote.priceDeltaInPercent.formatToString(
            minimumFractionDigits: StockQuoteTableViewCell.priceDeltaInPercentMaxDigitsAfterComma,
            maximumFractionDigits: StockQuoteTableViewCell.priceDeltaInPercentMaxDigitsAfterComma
        )
    }
    
    private func showBackground()
    {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        if quote.percentageDeltaIsPositive() {
            PriceDeltaInPercentLabel.backgroundColor = MyColors.percentage_green.getUIColor()
        } else {
            PriceDeltaInPercentLabel.backgroundColor = MyColors.percentage_green.getUIColor()
        }
        
        PriceDeltaInPercentLabel.textColor = MyColors.white.getUIColor()
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(
                timeInterval: self.timeInterval,
                target: self,
                selector: #selector(self.hideBackground),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    @objc
    private func hideBackground()
    {
        PriceDeltaInPercentLabel.backgroundColor = .clear
        
        if quote.percentageDeltaIsPositive() {
            PriceDeltaInPercentLabel.textColor = MyColors.percentage_green.getUIColor()
        } else {
            PriceDeltaInPercentLabel.textColor = MyColors.percentage_green.getUIColor()
        }
    }
}
