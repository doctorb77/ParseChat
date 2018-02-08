//
//  ChatCellTableViewCell.swift
//  ParseChat
//
//  Created by Brendan Raftery on 2/5/18.
//  Copyright © 2018 Brendan Raftery. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {


    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var bubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bubble.layer.cornerRadius = 10
        bubble.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
