//
//  DetailsProdcat.swift
//  MyWorld
//
//  Created by MyWorld on 12/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
class DetailsProdcats: Codable {
   
    
    let productlist:[DetailsProdcat]
    init(productlist:[DetailsProdcat]) {
        self.productlist = productlist
    }
}

class DetailsProdcat: Codable {
    
    let Percent:String
    let ProductsplPrice:String
    let brandName:String
    let brandmodelName:String
    let emailId:String
    //let location:String
    let productCreated:String
    let productDesp:String
    let productId:String
    let productImage1:String
    let productImage2:String
    let productImage3:String
    let productName:String
    let productPrice:String
    let productQuantity:String
    let productSku:String
    let userName:String
    
    init(Percent:String,ProductsplPrice:String,brandName:String,brandmodelName:String,emailId:String/*,location:String*/,productCreated:String,productDesp:String,productId:String,productImage1:String,productImage2:String,productImage3:String,productName:String,productPrice:String,productQuantity:String,productSku:String,userName:String) {
        
        
        self.Percent = Percent
        self.ProductsplPrice = ProductsplPrice
        self.brandName = brandName
        self.brandmodelName = brandmodelName
        self.emailId = emailId
        //self.location = location
        self.productCreated = productCreated
        self.productDesp = productDesp
        self.productId = productId
        self.productImage1 = productImage1
        self.productImage2 = productImage2
        self.productImage3 = productImage3
        self.productName = productName
        self.productPrice = productPrice
        self.productQuantity = productQuantity
        self.productSku = productSku
        self.userName = userName
    }
    
    
}
