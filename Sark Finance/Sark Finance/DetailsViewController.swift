//
//  DetailsViewController.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/18/22.
//

import UIKit
import Foundation

struct Root: Decodable {
    let results: Results
}

struct Results: Decodable {
    let branding: Branding
}

struct Branding: Decodable {
    let icon_url: String
    let logo_url: String
}



class DetailsViewController: UIViewController {
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyDetails: UILabel!
    
    var details = [String:Any]()
    var branding = [String:Any] ()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string:"https://api.polygon.io/v3/reference/tickers/AAPL?apiKey=iOuM5gLKJ37tjoCXjIW6elzWLRdbCsZw")!
        print(url)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                
                 
                 let resultsDict = try? JSONDecoder().decode(Root.self, from: data)

                 // Get array of movie videos
                 let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 

                
                 // Store movie video information in property
                 self.details = dataDictionary["results"] as! [String:Any]
                 
                 print(self.details)
                 self.companyName.text = (self.details["name"] as! String)
                
                 self.companyDetails.text = (self.details["description"] as! String)
                 
                 print(self.details["branding"] as Any)
                 
                 if let icon_url = resultsDict?.results.branding.icon_url {
                     print(icon_url)
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
