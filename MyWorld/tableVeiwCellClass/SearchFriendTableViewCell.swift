//
//  SearchFriendTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 29/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class SearchFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var imfSearchFriendEmailIds: UIImageView!
    
    @IBOutlet weak var lblSerchEmail: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    
    @IBOutlet weak var lblSerchEmailIds: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
