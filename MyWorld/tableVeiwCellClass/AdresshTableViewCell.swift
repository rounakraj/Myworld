//
//  AdresshTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 15/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class AdresshTableViewCell: UITableViewCell {
    @IBOutlet weak var btnCheckBox: UIButton!
    
    @IBOutlet weak var lblDefault: UILabel!
    @IBOutlet weak var lblAdressName: UILabel!
    @IBOutlet weak var lblAdress: UILabel!
    @IBOutlet weak var btnEditButton: UIButton!
    @IBOutlet weak var btnDeleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
