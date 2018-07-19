//
//  FriendListTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 11/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblFriendsEmailId: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblFriendsName: UILabel!
    @IBOutlet weak var btnUnfriend: UIButton!
    @IBOutlet weak var imageFriendsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
