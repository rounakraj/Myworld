//
//  SimilarTableViewCell.swift
//  MyWorld
//
//  Created by MyWorld on 05/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class SimilarTableViewCell: UITableViewCell {

    @IBOutlet weak var imgSimlar: UIImageView!
    
    @IBOutlet weak var lblSimilarProducatName: UILabel!
    
    @IBOutlet weak var lblSimilarPrice: UILabel!
    
    @IBOutlet weak var lblSimilarQuntiy: UILabel!
    
    @IBOutlet weak var lblSimilarQuntity: UILabel!
    
    @IBOutlet weak var lblSimilarPaymentMode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
