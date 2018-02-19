//
//  CrypCurrTableViewController.swift
//  CrypCurr Monitor
//
//  Created by kozlojak-home on 19.02.2018.
//  Copyright © 2018 Kozlojak-dev. All rights reserved.
//

import UIKit

class CrypCurrTableViewController: UITableViewController {

    let coinMarketCapURL = "https://api.coinmarketcap.com/v1/ticker/?start=0&limit=100.json"
    var currencies = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        getLatestCurrencies()
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
        return currencies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CrypCurrTableViewCell
        
        //Configure the cell...
        cell.nameLabel.text = currencies[indexPath.row].name
        cell.symbolLabel.text = currencies[indexPath.row].symbol
        cell.rankLabel.text = "#\(indexPath.row+1)"
        cell.priceLabel.text = "$\(currencies[indexPath.row].price)"

        return cell
    }
    
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
                print(self.currencies)
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
                    price: (jsonCurrency["price_usd"] as! NSString).floatValue as! Float
                )
                //Float = NSString(string: str).floatValue
                currencies.append(currency)
            }
            
           currencies = currencies.sorted(by: { $0.price > $1.price})
            
        }catch {
            print(error)
        }
        
        return currencies
        
        
        }

}
