//
//  MyAccountTVC.swift
//  MyWorld
//
//  Created by Shankar Kumar on 04/02/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class MyAccountTVC: UITableViewCell {
    @IBOutlet weak var switchBtn: UISwitch!
    
    @IBOutlet weak var blockUnBlockBtn: UILabel!
    

    @IBOutlet weak var blockSwitchBtn: UISwitch!
    
    @IBOutlet weak var reportSwitchBtn: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
