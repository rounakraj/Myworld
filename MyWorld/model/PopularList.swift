//
//  PopularList.swift
//  MyWorld
//
//  Created by MyWorld on 14/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class PopularLists:Codable{
    let productAll:[PopularList]
    init(productAll:[PopularList]){
        
    self.productAll = productAll
        
    }
}

class PopularList: Codable {
    
    
    let Percent:String
    let noHits:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let userName:String
    
    init(Percent:String,noHits:String,productId:String,productImage1:String,productName:String,productPrice:String,userName:String){
        self.Percent = Percent
        self.noHits = noHits
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.userName = userName
    }

}
