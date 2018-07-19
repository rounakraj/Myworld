//
//  TrendingList.swift
//  MyWorld
//
//  Created by MyWorld on 14/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class TrendingLists: Codable{
    
    let productAll:[TrendingList]
    
    init(productAll:[TrendingList]) {
        self.productAll = productAll
    }
}

class TrendingList: Codable {
    
    
    let Percent:String
    let noTrending:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let userName:String
    
    init(Percent:String,noTrending:String,productId:String,productImage1:String,productName:String,productPrice:String,userName:String) {
        self.Percent = Percent
        self.noTrending = noTrending
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.userName = userName
    }

}
