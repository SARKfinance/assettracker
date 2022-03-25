//
//  WatchlistTableViewController.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/24/22.
//

import UIKit
import Parse

struct TickerRoot: Decodable {
    let ticker: Ticker
}

struct Ticker: Decodable {
    let lastTrade: LastTrade
    let todaysChange: Double
    let todaysChangePerc: Double
}

struct LastTrade: Decodable {
    let p: Double
}


class WatchlistTableViewController: UITableViewController {
    
    
    let pgonk1 = "iOuM5gLKJ37tjo"
    let pgonk2 = "CXjIW6elzWLRdbCsZw"
    
    var watchlist = [PFObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: Notification.Name("refreshWatch"), object: nil, queue: OperationQueue.main) {(Notification) in
            print("Notification received!")
            // Call function to load investments from database
            self.loadWatchlist()
            
            
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadWatchlist()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return watchlist.count
    }
    
    // Sends query to Parse database to get the list of companies in the watchlist
    func loadWatchlist() {
        // Initialize array of investments
        self.watchlist = []
        // Reload table data to clear
        self.tableView.reloadData()
        
        // Query database for investments where the owner matches the user
        let user = PFUser.current()
        let query = PFQuery(className: "Watchlist")
        query.whereKey("owner", equalTo: user)
        
        query.findObjectsInBackground { (watchlist, error) in
            if watchlist != nil {
                // Save results into property and reload the data
                self.watchlist = watchlist!
                self.tableView.reloadData()
                
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var quoteResults = [String:Any]()
        let cell = tableView.dequeueReusableCell(withIdentifier: "WatchlistViewCell", for: indexPath) as! WatchlistViewCell
        let watchCompany = self.watchlist[indexPath.row]
        cell.watchCompany = watchCompany
        let ticker = watchCompany["ticker"] as! String
        let url = URL(string:"https://api.polygon.io/v2/snapshot/locale/us/markets/stocks/tickers/" + ticker + "?apiKey=" + self.pgonk1 + self.pgonk2)!
        print(url)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {

                 // Get array of movies
                 let resultsDict = try? JSONDecoder().decode(TickerRoot.self, from: data)
                 if let lastTrade = resultsDict?.ticker.lastTrade.p {
                     cell.tickerPrice.text = "$" + String(format: "%.2f", lastTrade)
                 }
                 if let todaysChange = resultsDict?.ticker.todaysChange {
                     if todaysChange < 0 {
                         cell.priceChange.text = "-$" + String(format: "%.2f", abs(todaysChange))
                         cell.priceChange.textColor = UIColor.systemRed
                     }
                     else if todaysChange > 0 {
                         cell.priceChange.text = "+$"+String(format: "%.2f", todaysChange)
                         cell.priceChange.textColor = UIColor.systemGreen
                     }
                     else {
                         cell.priceChange.text = "+$"+String(format: "%.2f", todaysChange)
                     }

                 }
                 if let percChange = resultsDict?.ticker.todaysChangePerc {
                     cell.percentChange.text = String(format: "%.2f", percChange)+"%"
                     if percChange < 0 {
                         cell.percentChange.text = String(format: "%.2f", percChange)+"%"
                         cell.percentChange.textColor = UIColor.systemRed
                     }
                     else if percChange > 0 {
                         cell.percentChange.text = "+" + String(format: "%.2f", percChange)+"%"
                         cell.percentChange.textColor = UIColor.systemGreen
                     }
                     else {
                         cell.percentChange.text = "+" + String(format: "%.2f", percChange)+"%"
                     }
                 }
                 
             }
            
        }
        task.resume()
        cell.tickerName.text = ticker

        return cell
    }
    
    @IBAction func onSignOut(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name:"Main", bundle:nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginViewController
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let myalert = UIAlertController(title: "Add Stock to Watchlist", message: "Please enter a ticker:", preferredStyle: .alert)
        myalert.addTextField { (textField) in
            textField.text = ""
        }
        myalert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak myalert] (_) in
            let textField = myalert?.textFields![0]
            if (textField!.text!.count > 0) {
                let watchlist = PFObject(className:"Watchlist")
                watchlist["ticker"] = textField?.text
                watchlist["owner"] = PFUser.current()!
                
                watchlist.saveInBackground { (success, error) in
                    if success {
                        // Print success message to console and go back to previous view controller
                        print("Watched company saved")
                        NotificationCenter.default.post(name: NSNotification.Name("refreshWatch"), object: nil)
                    }
                    else {
                        print("Error: \(error)")
                    }
                }
            }
            

            
        }))
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        myalert.addAction(cancel)
        
        self.present(myalert, animated:true, completion:nil)
        
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "watchDetails" {
            let cell = sender as! WatchlistViewCell
            let ticker = cell.tickerName.text
            
            let DetailsViewController = segue.destination as! DetailsViewController
            
            DetailsViewController.ticker = ticker!
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
