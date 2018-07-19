//
//  SearchDetails.swift
//  MyWorld
//
//  Created by MyWorld on 09/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
class SearchDetail:Codable{
    let productServer:[SearchDetails]
    init(productServer:[SearchDetails]){
        self.productServer = productServer
    }
}

class SerchDetai:Codable{
    let productUser:[SearchDetails]
    init(productUser:[SearchDetails]) {
        self.productUser = productUser
    }
}

class SearchDetails: Codable {

    
    let Percent:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let userName:String
    
    init(Percent:String,productId:String,productImage1:String,productName:String,productPrice:String,userName:String){
        self.Percent = Percent
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.userName = userName
    }
}
