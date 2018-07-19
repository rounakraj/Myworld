//
//  PaymentDetailData.swift
//  MyWorld
//
//  Created by Shankar Kumar on 09/03/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class PaymentDetailData:NSObject {
    
    static let shared:PaymentDetailData = {
        let shared = PaymentDetailData()
        return shared
    }()
    
    var cartID:String?
    var totalPrice:String?
    var addressID:String?

}
