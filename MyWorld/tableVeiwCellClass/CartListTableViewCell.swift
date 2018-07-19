//
//  CartListTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 01/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class CartListTableViewCell: UITableViewCell {
    @IBOutlet weak var imgCartList: UIImageView!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblSpecialPrice: UILabel!
    
    @IBOutlet weak var lblProductName: UILabel!

    
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var txtQty: UITextField!

    
    @IBOutlet weak var btnRemove: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
