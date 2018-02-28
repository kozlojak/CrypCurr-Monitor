//
//  CrypCurrTableViewController.swift
//  CrypCurr Monitor
//
//  Created by kozlojak-home on 19.02.2018.
//  Copyright © 2018 Kozlojak-dev. All rights reserved.
//

import UIKit

class CrypCurrTableViewController: UITableViewController, UISearchResultsUpdating {

    let coinMarketCapURL = "https://api.coinmarketcap.com/v1/ticker/?start=0&limit=100.json"
    var currencies = [Currency]()
    var searchController : UISearchController!
    var searchResults : [Currency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLatestCurrencies()
        
        //display Search Bar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive {
            return searchResults.count
        } else {
            return currencies.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CrypCurrTableViewCell
        
        //condition, whether table displays currencies or search results
        let currency = (searchController.isActive) ? searchResults[indexPath.row] : currencies[indexPath.row]
        
        cell.change24hLabel.layer.cornerRadius = 15.0
        cell.change24hLabel.clipsToBounds = true
        
        //Configure the cell...
        cell.nameLabel.text = currency.name
        cell.symbolLabel.text = currency.symbol
        cell.rankLabel.text = "#\(indexPath.row+1)"
        cell.priceLabel.text = "$\(currency.price)"
        if currency.change24h > 0 {
            cell.change24hLabel.backgroundColor = UIColor(red: 106.0/255.0, green: 193.0/255.0, blue: 34.0/255.0, alpha: 1)
            cell.change24hLabel.text = "+\(currency.change24h)%"
        } else if currency.change24h < 0{
            cell.change24hLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
            cell.change24hLabel.text = "\(currency.change24h)%"
        } else {
            cell.change24hLabel.backgroundColor = UIColor(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1)
            cell.change24hLabel.text = "\(currency.change24h)%"
        }
        
        
        return cell
    }
    
    //update of currencies
    func getLatestCurrencies() {
        guard let currURL = URL(string: coinMarketCapURL) else {
            return }
        let request = URLRequest(url: currURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if let error = error {
                print(error)
                return }
            //Parse JSON data
            if let data = data {
                print(data)
                self.currencies = self.parseJsonData(data: data)
               // print(self.currencies)
                //Reload table view
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            } })
        task.resume()
    }
    
    func parseJsonData(data: Data) -> [Currency] {
        var currencies = [Currency]()
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
            //Parse JSON data
            let jsonCurrencies = jsonResult as! [AnyObject]
            for jsonCurrency in jsonCurrencies {
                let currency = Currency(
                    name: jsonCurrency["name"] as! String,
                    symbol: jsonCurrency["symbol"] as! String,
                    price: (jsonCurrency["price_usd"] as! NSString).floatValue,
                    change24h: (jsonCurrency["percent_change_24h"] as! NSString).floatValue
                )
                //Float = NSString(string: str).floatValue
                currencies.append(currency)
            }
            
         //  currencies = currencies.sorted(by: { $0.price > $1.price})
            
        }catch {
            print(error)
        }
        
        return currencies
        
        
        }

    @IBAction func sortCurr (sender: AnyObject){
        
        let alert = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Name", style: .default) { _ in
            self.currencies = self.currencies.sorted { $0.name! < $1.name! }
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
        })
        
        alert.addAction(UIAlertAction(title: "Price", style: .default) { _ in
            self.currencies = self.currencies.sorted { $0.price > $1.price}
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            })
        

        self.present(alert, animated: true)
    }
    
    @IBAction func update (sender: UIBarButtonItem)
    {
        getLatestCurrencies()
    }
    
    func filterContent(for searchText : String) {
        searchResults = currencies.filter({ (currency) -> Bool in
            if let name = currency.name {
                if let symbol = currency.symbol {
                    let isMatch = name.localizedCaseInsensitiveContains(searchText) || symbol.localizedCaseInsensitiveContains(searchText)
                    return isMatch
                }
            }
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
}
