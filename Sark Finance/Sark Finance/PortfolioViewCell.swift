//
//  PortfolioViewCell.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/19/22.
//

import UIKit

class PortfolioViewCell: UITableViewCell {

    @IBOutlet weak var companyIcon: UIImageView!
    @IBOutlet weak var companyTicker: UILabel!
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var companyPrice: UILabel!
    
    @IBOutlet weak var qtyHeld: UILabel!
    
    
    @IBOutlet weak var currValue: UILabel!
    
    @IBOutlet weak var brokerageName: UILabel!
    
    var data: Data? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}