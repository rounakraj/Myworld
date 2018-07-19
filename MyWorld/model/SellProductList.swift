//
//  SellProductList.swift
//  MyWorld
//
//  Created by MyWorld on 12/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class SellProductList1:Codable{
    
    let productUser2:[SellProductList]
    init(productUser2:[SellProductList]){
        self.productUser2 = productUser2
    }
    
}

class SellProductList2: Codable{
    
    let productUser1:[SellProductList]
    
    init(productUser1:[SellProductList]){
         self.productUser1 = productUser1
    }
}

class SellProductList: Codable {
    
    let distance:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let userName:String

    init(distance:String,productId:String,productImage1:String,productName:String,productPrice:String,userName:String ){
        self.distance = distance
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.userName = userName
    }

}
