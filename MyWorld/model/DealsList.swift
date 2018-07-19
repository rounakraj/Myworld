//
//  DealsList.swift
//  MyWorld
//
//  Created by MyWorld on 14/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class DealsListServer:Codable{
    let productServer:[DealsList]
    init(productServer:[DealsList]){
        self.productServer = productServer
    }
}

class DealsListsUser:Codable{
    
    let productUser:[DealsList]
    init(productUser:[DealsList]){
        self.productUser = productUser
    }
}

class DealsList: Codable {
    
    let Percent:String
    let productId :String
    let productImage1:String
    let productName:String
    let productPrice:String
    let userName:String
    
    init(Percent:String,productId :String,productImage1:String,productName:String,productPrice:String,productsplPrice:String,userName:String){
        
        self.Percent = Percent
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.userName = userName

    }

}
