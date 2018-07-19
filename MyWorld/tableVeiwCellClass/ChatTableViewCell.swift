//
//  ChatTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 22/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var leftMessage: UILabel!
    
    @IBOutlet weak var rightMessage: UILabel!
    
    @IBOutlet weak var leftImageview: UIImageView!
    
    @IBOutlet weak var rightImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
