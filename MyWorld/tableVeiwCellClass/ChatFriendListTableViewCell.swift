//
//  ChatFriendListTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 21/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class ChatFriendListTableViewCell: UITableViewCell {
    @IBOutlet weak var ButtonMessage: UIButton!
    
    @IBOutlet weak var imageChatFriendImageview: UIImageView!
    
    @IBOutlet weak var lblChatFriendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
