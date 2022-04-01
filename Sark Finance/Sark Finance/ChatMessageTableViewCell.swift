//
//  ChatMessageTableViewCell.swift
//  Sark Finance
//
//  Created by Alan Kuo on 4/1/22.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var chatMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
