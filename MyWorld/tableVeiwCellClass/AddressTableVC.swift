//
//  AddressTableVC.swift
//  MyWorld
//
//  Created by MyWorld on 04/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class AddressTableVC: UITableViewCell {
    @IBOutlet weak var btnCheckBox: UIButton!
    
    
    
    @IBOutlet weak var lblNameAddress: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnPencil: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
