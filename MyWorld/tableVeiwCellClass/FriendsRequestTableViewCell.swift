//
//  FriendsRequestTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 05/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class FriendsRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var imageFR: UIImageView!
    
    @IBOutlet weak var lblFRName: UILabel!
    
    @IBOutlet weak var btnFRButton: UIButton!
    @IBOutlet weak var lblFREmailId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
