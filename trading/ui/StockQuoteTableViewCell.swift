//
//  StockQuoteTableViewCell.swift
//  trading
//
//  Created by Aleksey Grebenkin on 09.09.23.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit

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
    static var priceMinDigitsAfterComma = 2
    static var priceDeltaMinDigitsAfterComma = 2
    
    var quote: StockQuoteModel!
    var timer: Timer?
    var backgroundPriceDeltaInPercentLightiningTimeInterval: Double = 0.3
    
    override func prepareForReuse()
    {
        TickerLabel.text = nil
        PriceDeltaInPercentLabel.text = nil
        MarketAndStockNameLabel.text = nil
        StockLogoImageView.image = nil
        PriceDeltaLabel.text = nil
        PriceLabel.text = nil
        
        timer?.invalidate()
        timer = nil
        quote = nil
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
        
        TickerLabel.leftInset = 5
        
        PriceLabel.rightInset = 5
    }
    
    func bindData(quote: StockQuoteModel)
    {
        self.quote = quote
        
        setPriceDeltaInPercent()
        
        TickerLabel.text = quote.ticker.uppercased()
        MarketAndStockNameLabel.text = quote.lastTradeMarketName!.uppercased() + " | " + quote.stockName!
        
        setPriceLabel()
        setDeltaPriceLabel()
        setLogo()
        
        self.setNeedsLayout()
    }
    
    private func setPriceLabel()
    {
        let maxDigitsAfterComma = quote.minStep != nil ? quote.minStep!.numberOfDigitsAfterComma() : StockQuoteTableViewCell.priceMinDigitsAfterComma
        let minDigitsAfterComma = min(maxDigitsAfterComma, StockQuoteTableViewCell.priceMinDigitsAfterComma)
        
        PriceLabel.text = quote.currentPrice!.formatToString(
            minimumFractionDigits: minDigitsAfterComma,
            maximumFractionDigits: maxDigitsAfterComma
        )
    }
    
    private func setDeltaPriceLabel()
    {
        let maxDigitsAfterComma = quote.minStep != nil ? quote.minStep!.numberOfDigitsAfterComma() : StockQuoteTableViewCell.priceDeltaMinDigitsAfterComma
        let minDigitsAfterComma = min(maxDigitsAfterComma, StockQuoteTableViewCell.priceDeltaMinDigitsAfterComma)
        
        PriceDeltaLabel.text =
            "( " +
            quote.priceDelta!.formatToString(
                minimumFractionDigits: minDigitsAfterComma,
                maximumFractionDigits: maxDigitsAfterComma
            ) +
            " )"
    }
    
    private func setPriceDeltaInPercent()
    {
        
        showPriceDeltaInPercentBackground()
    
        PriceDeltaInPercentLabel.text = quote.priceDeltaInPercent!.formatToString(
            minimumFractionDigits: StockQuoteTableViewCell.priceDeltaInPercentMaxDigitsAfterComma,
            maximumFractionDigits: StockQuoteTableViewCell.priceDeltaInPercentMaxDigitsAfterComma
        )
    }
    
    private func setLogo()
    {
        self.StockLogoImageView.kf.setImage(
            with: quote.stockLogo,
            options: [
                .transition(ImageTransition.fade(0.3)),
                .cacheOriginalImage,
                .keepCurrentImageWhileLoading,
                .backgroundDecode,
                .fromMemoryCacheOrRefresh
            ],
            completionHandler: { [weak self] result in
                
                guard let self = self else { return }
                
                if case .success(_) = result {
                    self.StockLogoImageView.snp.remakeConstraints({ make in
                        make.width.height.equalTo(20)
                    })
                }
                if case .failure(_) = result {
                    self.StockLogoImageView.snp.remakeConstraints({ make in
                        make.width.height.equalTo(0)
                    })
                }
            }
        )
    }
    
    private func showPriceDeltaInPercentBackground()
    {
        guard quote.trend != .none else {
            hidePriceDeltaInPercentBackground()
            return
        }
            
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        if quote.trend == .positive {
            PriceDeltaInPercentLabel.backgroundColor = MyColors.percentage_green.getUIColor()
        } else {
            PriceDeltaInPercentLabel.backgroundColor = MyColors.percentage_red.getUIColor()
        }
        
        PriceDeltaInPercentLabel.textColor = MyColors.white.getUIColor()
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(
                timeInterval: self.backgroundPriceDeltaInPercentLightiningTimeInterval,
                target: self,
                selector: #selector(self.hidePriceDeltaInPercentBackground),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    @objc
    private func hidePriceDeltaInPercentBackground()
    {
        PriceDeltaInPercentLabel.backgroundColor = .clear
        
        if quote.priceDeltaInPercent == nil || quote.priceDeltaInPercent! >= 0 {
            PriceDeltaInPercentLabel.textColor = MyColors.percentage_green.getUIColor()
        } else {
            PriceDeltaInPercentLabel.textColor = MyColors.percentage_red.getUIColor()
        }
    }
}
