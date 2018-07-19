//
//  FollowersTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 11/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class FollowersTableViewCell: UITableViewCell {
    @IBOutlet weak var lblFollowerFrName: UILabel!
    
    @IBOutlet weak var imgFollowerimaigeview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
