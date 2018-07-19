//
//  FriendReqestTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 11/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class FriendReqestTableViewCell: UITableViewCell {

    @IBOutlet weak var imgRequest: UIImageView!
    
    @IBOutlet weak var lblRequestName: UILabel!
    
    @IBOutlet weak var btnAccept: UIButton!
    
    @IBOutlet weak var btnReject: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
