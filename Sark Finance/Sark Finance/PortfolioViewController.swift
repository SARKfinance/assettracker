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
    var companies = [String]()
    var investments = [PFObject]()
    
    
//    var companies = ["AAPL", "DIS", "BBY", "Z", "CMG"]
    
    
    let pgonk1 = "iOuM5gLKJ37tjo"
    let pgonk2 = "CXjIW6elzWLRdbCsZw"
    var total: Double = 0
    
    
    @IBAction func signOut(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name:"Main", bundle:nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginViewController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: Notification.Name("refresh"), object: nil, queue: OperationQueue.main) {(Notification) in
            print("Notification received!")
            self.total = 0
            self.loadInvestments()
            
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.total = 0
        loadInvestments()
    }
    
    func loadInvestments() {
        self.investments = []
        self.tableView.reloadData()
        
        let user = PFUser.current()
        let query = PFQuery(className: "investments")
        query.whereKey("owner", equalTo: user)
        
        query.findObjectsInBackground { (investments, error) in
            if investments != nil {
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return investments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioViewCell") as! PortfolioViewCell
        
        let investment = self.investments[indexPath.row]
        cell.investment = investment
        
//        let url = URL(string:"https://api.polygon.io/v3/reference/tickers/" + companies[indexPath.row] + "?apiKey=" + self.pgonk1 + self.pgonk2)!
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


                 
                 
                 // Format date as Month Day, Year
                 if let dateString = resultsDict?.results.list_date {
                     let dateParser = DateFormatter()
                     dateParser.dateFormat = "yyyy-MM-dd"
                     
                     let datePrint = DateFormatter()
                     datePrint.dateFormat = "MMM dd, yyyy"
                     
                     let formattedDate: NSDate? = dateParser.date(from: dateString) as NSDate?

                     
                 }
                 
                 // Display number of employees with commas
                 if let numEmployees = resultsDict?.results.total_employees {
                     let commaFormat = NumberFormatter()
                     commaFormat.numberStyle = .decimal
                     //self.companyEmployees.text = commaFormat.string(from: NSNumber(value: numEmployees))
                 }
                 
                 // Display number of shares in millions/trillions
                 if let numShares = resultsDict?.results.share_class_shares_outstanding {
                 }
                 
                 // Display market cap with 2 decimal places and in millions/trillions/billions
                 if let mktCap = resultsDict?.results.market_cap {
                     var sharePrice:Double = ((resultsDict?.results.market_cap)!/Double((resultsDict?.results.share_class_shares_outstanding)!))
                     let numShares = Double(investment["numShares"] as! String) ?? 0
                     let totalValue = sharePrice * numShares
                     
                     
                     
                     cell.companyPrice.text = sharePrice.currencyWithSeparator
                     cell.currValue.text = totalValue.currencyWithSeparator
                     
                     self.total += totalValue
                     self.title = String("Portfolio: " + self.total.currencyWithSeparator)
                     //self.companyMktCap.text = mktCap.roundedWithCurrAbbrev
                 }
                 
                 
                 cell.companyIcon.image = nil
                 
                 // Parse out icon url, then create request with bearer authorization token and set image with AF
                 if let icon_url = resultsDict?.results.branding.icon_url {
                     
                     var iconRequest = URLRequest(url: URL(string: icon_url)!)
                     iconRequest.addValue("Bearer " + "iOuM5gLKJ37tjoCXjIW6elzWLRdbCsZw", forHTTPHeaderField: "Authorization")
                     cell.companyIcon.af.setImage(withURLRequest: iconRequest)
                     

                     //self.companyLogo.af.setImage(withURLRequest: iconRequest)
                 }

             }
        }
        task.resume()
        
        cell.companyTicker.text = investment["ticker"] as! String
        cell.qtyHeld.text = investment["numShares"] as! String
        cell.brokerageName.text = investment["brokerage"] as! String

        cell.editButton.addTarget(self, action: #selector(testAction), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        return cell
    }
    
    @objc func testAction(sender: UIButton) {
        print(sender.tag)
        performSegue(withIdentifier: "editSegue", sender: sender)
    }
    
    @objc
    func didPressLabel (_ sender:UITapGestureRecognizer) {
        print("Label tapped!")
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
