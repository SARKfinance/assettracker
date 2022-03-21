//
//  PortfolioViewController.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/18/22.
//

import UIKit
import Parse


// Set up decodable struct for parsing API response
struct Root: Decodable {
    let results: Results
}

struct Results: Decodable {
    let branding: Branding
    let name: String
    let description: String
    let ticker_root: String
    let total_employees: Int
    let list_date: String
    let share_class_shares_outstanding: Int
    let market_cap: Double
    
}

struct Branding: Decodable {
    let icon_url: String?
    let logo_url: String?
}


class PortfolioViewController: UITableViewController  {
    // Set up Array of PFObjects to hold results from API call
    var investments = [PFObject]()
    
    // Slightly obfuscated API key
    let pgonk1 = "iOuM5gLKJ37tjo"
    let pgonk2 = "CXjIW6elzWLRdbCsZw"
    // Variable to keep track of total portfolio valuex
    var total: Double = 0
    
    
    // Function for initial view load
    override func viewDidLoad() {
        // Add notification center listener for table refresh
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: Notification.Name("refresh"), object: nil, queue: OperationQueue.main) {(Notification) in
            print("Notification received!")
            // Set total value of portfolio to zero
            self.total = 0
            // Call function to load investments from database
            self.loadInvestments()
            
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set total value of portfolio to zero
        self.total = 0
        // Call function to load investments from database
        loadInvestments()
    }
    
    func loadInvestments() {
        // Initialize array of investments
        self.investments = []
        // Reload table data to clear
        self.tableView.reloadData()
        
        // Query database for investments where the owner matches the user
        let user = PFUser.current()
        let query = PFQuery(className: "investments")
        query.whereKey("owner", equalTo: user)
        
        query.findObjectsInBackground { (investments, error) in
            if investments != nil {
                // Save results into property and reload the data
                self.investments = investments!
                self.tableView.reloadData()
                
            }
        }
    }
    
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem


    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    // Should have the same number of rows as the number of investments returned by the database call
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return investments.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioViewCell") as! PortfolioViewCell
        
        // Set the investment for this cell and save it as a property
        let investment = self.investments[indexPath.row]
        cell.investment = investment
        
        // Set up for API call to get stock data (primarily for the company name and the icon)
        let url = URL(string:"https://api.polygon.io/v3/reference/tickers/" + (investment["ticker"] as! String) + "?apiKey=" + self.pgonk1 + self.pgonk2)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                
                 // Decode JSON dictionary with Decodable structs
                 let resultsDict = try? JSONDecoder().decode(Root.self, from: data)
                 
                 // Save raw data to cell to pass to details if pressed
                 cell.data = data
                 
                 cell.companyName.text = resultsDict?.results.name
                 
                 
                 // Second nested API call to get 15 minute delayed price
                 // Initialize Array of dictionaries to hold the results from second API call (for 15 minute delayed price)
                 var liveResults = [String:Any]()
                 // Set up second API call
                 let url = URL(string:"https://api.polygon.io/v2/last/nbbo/" + (investment["ticker"] as! String) + "?apiKey=" + self.pgonk1 + self.pgonk2)!
                 let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                 let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                 let task = session.dataTask(with: request) { (data, response, error) in
                      // This will run when the network request returns
                      if let error = error {
                             print(error.localizedDescription)
                      } else if let data = data {
                          // Get array of movies
                          let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                         
                          // Store movies in property
                          liveResults = dataDictionary["results"] as! [String:Any]
                          
                          // Get share price value and calculate total value
                          let sharePrice = (liveResults["P"] as! NSNumber).doubleValue
                          let numShares = Double(investment["numShares"] as! String) ?? 0
                          let totalValue = sharePrice * numShares
                          
                          // Update label text
                          cell.companyPrice.text = sharePrice.currencyWithSeparator
                          cell.currValue.text = totalValue.currencyWithSeparator
                          
                          // Update the total value in the view controller title
                          self.total += totalValue
                          self.title = String("Portfolio: " + self.total.currencyWithSeparator)
                      }
                 }
                 task.resume()
                 
                 // Clear icon image
                 cell.companyIcon.image = nil
                 
                 // Parse out icon url, then create request with bearer authorization token and set image with AF
                 if let icon_url = resultsDict?.results.branding.icon_url {
                     var iconRequest = URLRequest(url: URL(string: icon_url)!)
                     iconRequest.addValue("Bearer " + "iOuM5gLKJ37tjoCXjIW6elzWLRdbCsZw", forHTTPHeaderField: "Authorization")
                     cell.companyIcon.af.setImage(withURLRequest: iconRequest)
                 }

             }
        }
        task.resume()
        
        // Set ticker, qty, brokerage name labels
        cell.companyTicker.text = investment["ticker"] as! String
        cell.qtyHeld.text = investment["numShares"] as! String
        cell.brokerageName.text = investment["brokerage"] as! String

        // Set up action for the edit button
        cell.editButton.addTarget(self, action: #selector(pressEditButton), for: .touchUpInside)
        // Add tag to edit button to specify in which cell the edit button was pressed
        cell.editButton.tag = indexPath.row
        return cell
    }
    
    
    // Function called when edit button is pressed -> performs segue to edit screen
    @objc func pressEditButton(sender: UIButton) {
        performSegue(withIdentifier: "editSegue", sender: sender)
    }
    
    // Function for signing out via the navigation bar button
    @IBAction func signOut(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name:"Main", bundle:nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginViewController
        
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
        
        if segue.identifier == "detailsSegue" {
            // Prepare to pass cell data and ticker information to the details view
            let cell = sender as! PortfolioViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let ticker = investments[indexPath.row]["ticker"]
            
            let DetailsViewController = segue.destination as! DetailsViewController
            DetailsViewController.ticker = ticker as! String
            // Pass raw data to details view from cell
            DetailsViewController.data = cell.data
        }
        
        // Need to pass the specific investment object to editing
        if segue.identifier == "editSegue" {
            let button = sender as! UIButton
            let selectedInvestment = investments[button.tag]
            let EditViewController = segue.destination as! EditViewController
            EditViewController.investment = selectedInvestment
        }
        


        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
