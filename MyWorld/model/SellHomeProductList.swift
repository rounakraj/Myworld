//
//  SellHomeProductList.swift
//  MyWorld
//
//  Created by MyWorld on 15/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class SellHomeProductList1:Codable{
    
    let productServer:[SellHomeProductList]
    
    init(productServer:[SellHomeProductList]){
        self.productServer = productServer
    }
    
}

class SellHomeProductList2: Codable{
    
    let productUser:[SellHomeProductList]
    
    init(productUser:[SellHomeProductList]){
        
        self.productUser = productUser
    }
}

class SellHomeProductList: Codable {
    
    
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
