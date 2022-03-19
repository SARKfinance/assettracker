//
//  PortfolioViewController.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/18/22.
//

import UIKit
import Parse

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
    var companies = ["AAPL", "DIS", "BBY", "Z", "CMG"]
    
    
    
    @IBAction func signOut(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name:"Main", bundle:nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginViewController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return companies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioViewCell") as! PortfolioViewCell
        
        let url = URL(string:"https://api.polygon.io/v3/reference/tickers/" + companies[indexPath.row] + "?apiKey=iOuM5gLKJ37tjoCXjIW6elzWLRdbCsZw")!
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
                 
                // Set company name and details
//                 self.companyName.text = resultsDict?.results.name
//                 self.companyDetails.text = resultsDict?.results.description
//                 
//                 self.companyTicker.text = resultsDict?.results.ticker_root
                 
                 

                 //self.companySharePrice.text = String(format: "$%.2f", sharePrice)
                 
                 
                 // Format date as Month Day, Year
                 if let dateString = resultsDict?.results.list_date {
                     let dateParser = DateFormatter()
                     dateParser.dateFormat = "yyyy-MM-dd"
                     
                     let datePrint = DateFormatter()
                     datePrint.dateFormat = "MMM dd, yyyy"
                     
                     let formattedDate: NSDate? = dateParser.date(from: dateString) as NSDate?
                     
                     //self.companyDate.text = datePrint.string(from: formattedDate! as Date)
                     
                 }
                 
                 // Display number of employees with commas
                 if let numEmployees = resultsDict?.results.total_employees {
                     let commaFormat = NumberFormatter()
                     commaFormat.numberStyle = .decimal
                     //self.companyEmployees.text = commaFormat.string(from: NSNumber(value: numEmployees))
                 }
                 
                 // Display number of shares in millions/trillions
                 if let numShares = resultsDict?.results.share_class_shares_outstanding {
                     //self.companyShares.text = numShares.roundedWithAbbrev
                 }
                 
                 // Display market cap with 2 decimal places and in millions/trillions/billions
                 if let mktCap = resultsDict?.results.market_cap {
                     var sharePrice:Double = ((resultsDict?.results.market_cap)!/Double((resultsDict?.results.share_class_shares_outstanding)!))
                     cell.companyPrice.text = String(format: "$%.2f", sharePrice)
                     //self.companyMktCap.text = mktCap.roundedWithCurrAbbrev
                 }
                 
                 
                 
                 
                 // Parse out icon url, then create request with bearer authorization token and set image with AF
                 if let icon_url = resultsDict?.results.branding.icon_url {
                     print(icon_url)
                     
                     var iconRequest = URLRequest(url: URL(string: icon_url)!)
                     iconRequest.addValue("Bearer " + "iOuM5gLKJ37tjoCXjIW6elzWLRdbCsZw", forHTTPHeaderField: "Authorization")
                     cell.companyIcon.af.setImage(withURLRequest: iconRequest)
                     

                     //self.companyLogo.af.setImage(withURLRequest: iconRequest)
                 }

             }
        }
        task.resume()
        
        
        cell.companyTicker.text = companies[indexPath.row]
        

        return cell
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
        
        
        // Prepare to pass cell data and ticker information to the details view
        let cell = sender as! PortfolioViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let ticker = companies[indexPath.row]
        
        let DetailsViewController = segue.destination as! DetailsViewController
        DetailsViewController.ticker = ticker
        // Pass raw data to details view from cell
        DetailsViewController.data = cell.data

        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
