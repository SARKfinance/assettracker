//
//  DetailsViewController.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/18/22.
//

import UIKit
import Foundation
import AlamofireImage




class DetailsViewController: UIViewController {
    // Outlets for data
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyDetails: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companySharePrice: UILabel!
    @IBOutlet weak var companyDate: UILabel!
    @IBOutlet weak var companyEmployees: UILabel!
    @IBOutlet weak var companyShares: UILabel!
    @IBOutlet weak var companyMktCap: UILabel!
    @IBOutlet weak var companyTicker: UILabel!
    
    // Property to hold parsed results from data
    var details = [String:Any]()
    // Property to hold parsed results regarding branding
    var branding = [String:Any] ()
    // Property to hold the name of the ticker to show details for
    var ticker: String = ""
    
    let pgonk1 = "polygonKeyPart1"
    let pgonk2 = "polygonKeyPart2"
    
    // Called when user wants to exit detail screen
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string:"https://api.polygon.io/v3/reference/tickers/" + (self.ticker) + "?apiKey=" + self.pgonk1 + self.pgonk2)!
        print(url)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                
                 // Decode JSON dictionary with Decodable structs
                 let resultsDict = try? JSONDecoder().decode(Root.self, from: data)
                 
                 self.companyName.text = resultsDict?.results.name
                 self.companyDetails.text = resultsDict?.results.description
                 self.companyTicker.text = resultsDict?.results.ticker_root
                 // Format date as Month Day, Year
                 if let dateString = resultsDict?.results.list_date {
                     let dateParser = DateFormatter()
                     dateParser.dateFormat = "yyyy-MM-dd"

                     let datePrint = DateFormatter()
                     datePrint.dateFormat = "MMM dd, yyyy"

                     let formattedDate: NSDate? = dateParser.date(from: dateString) as NSDate?

                     self.companyDate.text = datePrint.string(from: formattedDate! as Date)

                 }

                 // Display number of employees with commas
                 if let numEmployees = resultsDict?.results.total_employees {
                     let commaFormat = NumberFormatter()
                     commaFormat.numberStyle = .decimal
                     self.companyEmployees.text = commaFormat.string(from: NSNumber(value: numEmployees))
                 }

                 // Display number of shares in millions/trillions
                 if let numShares = resultsDict?.results.share_class_shares_outstanding {
                     self.companyShares.text = numShares.roundedWithAbbrev
                 }

                 // Display market cap with 2 decimal places and in millions/trillions/billions. Get last close share price by dividing market cap by outstanding shares
                 if let mktCap = resultsDict?.results.market_cap {
                     self.companyMktCap.text = mktCap.roundedWithCurrAbbrev
                     var sharePrice:Double = ((resultsDict?.results.market_cap)!/Double((resultsDict?.results.share_class_shares_outstanding)!))
                     self.companySharePrice.text = String(format: "$%.2f", sharePrice)
                 }


                 // Parse out icon url, then create request with bearer authorization token and set image with AF
                 if let icon_url = resultsDict?.results.branding.icon_url {
                     var iconRequest = URLRequest(url: URL(string: icon_url)!)
                     iconRequest.addValue("Bearer " + "iOuM5gLKJ37tjoCXjIW6elzWLRdbCsZw", forHTTPHeaderField: "Authorization")
                     // Set company logo
                     self.companyLogo.af.setImage(withURLRequest: iconRequest)
                 }
             }
            
        }
        task.resume()
    }
        
//        // Decode JSON dictionary with Decodable structs
//        let resultsDict = try? JSONDecoder().decode(Root.self, from: self.data!)
//
//       // Set company name, details, and ticker
//        self.companyName.text = resultsDict?.results.name
//        self.companyDetails.text = resultsDict?.results.description
//        self.companyTicker.text = resultsDict?.results.ticker_root
//
//
//
//
//        // Format date as Month Day, Year
//        if let dateString = resultsDict?.results.list_date {
//            let dateParser = DateFormatter()
//            dateParser.dateFormat = "yyyy-MM-dd"
//
//            let datePrint = DateFormatter()
//            datePrint.dateFormat = "MMM dd, yyyy"
//
//            let formattedDate: NSDate? = dateParser.date(from: dateString) as NSDate?
//
//            self.companyDate.text = datePrint.string(from: formattedDate! as Date)
//
//        }
//
//        // Display number of employees with commas
//        if let numEmployees = resultsDict?.results.total_employees {
//            let commaFormat = NumberFormatter()
//            commaFormat.numberStyle = .decimal
//            self.companyEmployees.text = commaFormat.string(from: NSNumber(value: numEmployees))
//        }
//
//        // Display number of shares in millions/trillions
//        if let numShares = resultsDict?.results.share_class_shares_outstanding {
//            self.companyShares.text = numShares.roundedWithAbbrev
//        }
//
//        // Display market cap with 2 decimal places and in millions/trillions/billions. Get last close share price by dividing market cap by outstanding shares
//        if let mktCap = resultsDict?.results.market_cap {
//            self.companyMktCap.text = mktCap.roundedWithCurrAbbrev
//            var sharePrice:Double = ((resultsDict?.results.market_cap)!/Double((resultsDict?.results.share_class_shares_outstanding)!))
//            self.companySharePrice.text = String(format: "$%.2f", sharePrice)
//        }
//
//
//        // Parse out icon url, then create request with bearer authorization token and set image with AF
//        if let icon_url = resultsDict?.results.branding.icon_url {
//            var iconRequest = URLRequest(url: URL(string: icon_url)!)
//            iconRequest.addValue("Bearer " + "iOuM5gLKJ37tjoCXjIW6elzWLRdbCsZw", forHTTPHeaderField: "Authorization")
//            // Set company logo
//            self.companyLogo.af.setImage(withURLRequest: iconRequest)
//        }
        

        // Do any additional setup after loading the view.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
