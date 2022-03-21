//
//  PortfolioViewCell.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/19/22.
//

import UIKit
import Parse

class PortfolioViewCell: UITableViewCell {

    @IBOutlet weak var companyIcon: UIImageView!
    @IBOutlet weak var companyTicker: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyPrice: UILabel!
    @IBOutlet weak var qtyHeld: UILabel!
    @IBOutlet weak var currValue: UILabel!
    @IBOutlet weak var brokerageName: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    // Used to cache data from initial API call - passed to DetailsViewController on segue
    var data: Data? = nil
    // Each cell saves the investment object that it is assigned to (to have a reference for deleting and updating)
    var investment = PFObject(className: "investments")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // Function for deleting an investment from the database when the delete button is pressed
    // Uses notification center to send notification to the tableviewcontroller that it should reload the table
    // after the investment object has been deleted
    @IBAction func deleteInvestment(_ sender: Any) {
        // Use blocking delete function
        do {
            try investment.delete()
        }
        catch {
            print("Unable to delete investment")
        }
        // Tell TableViewController to refresh the table data after deletion is complete
        NotificationCenter.default.post(name: NSNotification.Name("refresh"), object: nil)
        print("Deleted investment!")
    }
    
    

    
    
}
