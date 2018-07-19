//
//  OrderHistoryTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 06/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var imgHistory: UIImageView!
    @IBOutlet weak var lblHsProductName: UILabel!
    @IBOutlet weak var lblHsPrice: UILabel!
    @IBOutlet weak var lblHistorySpecialPrice: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblHistoryDate: UILabel!
    @IBOutlet weak var lblHistoryPaymentType: UILabel!
    @IBOutlet weak var btnDropeDown: UIButton!
    @IBOutlet weak var procview: UIView!
    
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var date3: UILabel!
    @IBOutlet weak var date4: UILabel!
    @IBOutlet weak var date5: UILabel!
    
    @IBOutlet weak var circle1: UIImageView!
    @IBOutlet weak var circle2: UIImageView!
    @IBOutlet weak var circle3: UIImageView!
    @IBOutlet weak var circle4: UIImageView!
    @IBOutlet weak var circle5: UIImageView!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var line3: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
