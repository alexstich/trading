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
    }
    
    private func setConfigTable()
    {
        title = "Stock list"
                
        tableView.bounces = false
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
    }
    
    private func setEvents()
    {
        vm?.stockQuotes.subscribe(
            onNext:{ [weak self] stockQuotes in
                
                let oldItems = self?.stockQuotes ?? [StockQuoteModel]()
                let newItems = stockQuotes
                let changes = diff(old: oldItems, new: newItems)

                self?.tableView.reload(changes: changes, section: 0, updateData: { [weak self] in
                  self?.stockQuotes = newItems
                })
            }
        ).disposed(by: disposeBag)
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


