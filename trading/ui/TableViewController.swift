//
//  ViewController.swift
//  trading
//
//  Created by Aleksey Grebenkin on 08.09.23.
//

import UIKit
import RxSwift
import DeepDiff

class TableViewController: UITableViewController
{
    private let disposeBag: DisposeBag = DisposeBag()
    
    private var vm: StockQuotesListViewModel?
    
    private var stockQuotes: [StockQuoteModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setConfigTable()
        
        vm = StockQuotesListViewModel()
        
        setEvents()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        vm?.observeQuotes()
    }
    
    private func setConfigTable()
    {
        title = "Stock list"
                
        tableView.bounces = true
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.tintColor = MyColors.loader.getUIColor()
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func appDidBecomeActive()
    {
        vm?.observeQuotes()
    }
    
    @objc
    private func refresh()
    {
        vm?.stockQuotes.onNext([])
        vm?.observeQuotes()
        refreshControl?.endRefreshing()
    }
    
    private func setEvents()
    {
        vm?.stockQuotes
            .subscribe(
            onNext:{ [weak self] stockQuotes_ in
                
                guard let self = self else { return }
                
//                self.stockQuotes = stockQuotes_
//                self.tableView.reloadData()
                
                let newItems = stockQuotes_
                let oldItems = self.stockQuotes

                let changes = diff(old: oldItems, new: newItems)

                UIView.performWithoutAnimation {
                    self.tableView.reload(changes: changes, section: 0, updateData: { [weak self] in
                        self?.stockQuotes = newItems
                    })
                }
                
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return stockQuotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let quote = stockQuotes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StockQuoteTableViewCell.reuseId, for: indexPath) as! StockQuoteTableViewCell
        
        cell.bindData(quote: quote)
        
        return cell
    }
}


