//
//  WatchlistViewCell.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/24/22.
//

import UIKit

class WatchlistViewCell: UITableViewCell {

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

}
