//
//  WatchlistViewCell.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/24/22.
//

import UIKit
import Parse

class WatchlistViewCell: UITableViewCell {
    
    var watchCompany = PFObject(className:"Watchlist")

    @IBOutlet weak var tickerName: UILabel!
    
    @IBOutlet weak var tickerPrice: UILabel!
    
    @IBOutlet weak var priceChange: UILabel!
    
    @IBOutlet weak var percentChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Delete the watchlist company saved for this cell
    @IBAction func onDelete(_ sender: Any) {
        do {
            try watchCompany.delete()
        }
        catch {
            print("Unable to delete watched company")
        }
        // Tell TableViewController to refresh the table data after deletion is complete
        NotificationCenter.default.post(name: NSNotification.Name("refreshWatch"), object: nil)
        print("Deleted watched company!")
    }
}
