//
//  DetailsViewController.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/18/22.
//

import UIKit
import Foundation
import AlamofireImage

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



class DetailsViewController: UIViewController {
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyDetails: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companyTicker: UILabel!
    @IBOutlet weak var companyDate: UILabel!
    @IBOutlet weak var companyEmployees: UILabel!
    @IBOutlet weak var companyShares: UILabel!
    @IBOutlet weak var companyMktCap: UILabel!
    
    var details = [String:Any]()
    var branding = [String:Any] ()
    var ticker: String = ""
    

   
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string:"https://api.polygon.io/v3/reference/tickers/" + self.ticker + "?apiKey=iOuM5gLKJ37tjoCXjIW6elzWLRdbCsZw")!
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
                 
                // Set company name and details
                 self.companyName.text = resultsDict?.results.name
                 self.companyDetails.text = resultsDict?.results.description
                 
                 self.companyTicker.text = resultsDict?.results.ticker_root
                 self.companyDate.text = resultsDict?.results.list_date
                 if let numEmployees = resultsDict?.results.total_employees {
                     self.companyEmployees.text = String(numEmployees)
                 }
                 if let numShares = resultsDict?.results.share_class_shares_outstanding {
                     self.companyShares.text = String(numShares)
                 }
                 
                 if let mktCap = resultsDict?.results.market_cap {
                     
                     let currFormatter = NumberFormatter()
                     currFormatter.numberStyle = .currency
                     self.companyMktCap.text = currFormatter.string(from: NSNumber(value: mktCap))
                 }
                 
                 
                 
                 
                 // Parse out icon url, then create request with bearer authorization token and set image with AF
                 if let icon_url = resultsDict?.results.branding.icon_url {
                     print(icon_url)
                     
                     var iconRequest = URLRequest(url: URL(string: icon_url)!)
                     iconRequest.addValue("Bearer " + "iOuM5gLKJ37tjoCXjIW6elzWLRdbCsZw", forHTTPHeaderField: "Authorization")

                     

                     self.companyLogo.af.setImage(withURLRequest: iconRequest)
                 }

             }
        }
        task.resume()
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
