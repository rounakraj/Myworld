//
//  ProductDetailsList.swift
//  MyWorld
//
//  Created by MyWorld on 18/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class ProductDetailsLists:Codable{
    
    let productlist:[ProductDetailsList]
    init(productlist:[ProductDetailsList])
    {
        self.productlist = productlist
    }
}

class ProductDetailsList: Codable {
    
    let Percent:String
    let ProductsplPrice:String
    let brandName:String
    let brandmodelName:String
    let emailId:String
    let location:String
    let latiTude:String
    let longiTude:String
    let productCondition:String
    let productCreated:String
    let productDesp:String
    let productId:String
    let productImage1:String
    let productImage2:String
    let productImage3:String
    let productName:String
    let productPrice:String
    let productYear:String
    let userId:String
    let userName:String
    
    init(Percent:String,ProductsplPrice:String,brandName:String,brandmodelName:String,emailId:String,location:String,latiTude:String,longiTude:String,productCondition:String,productCreated:String,productDesp:String,productId:String,productImage1:String,productImage2:String,productImage3:String,productName:String,productPrice:String,productYear:String,userId:String,userName:String) {
    
        self.Percent = Percent
        self.ProductsplPrice = ProductsplPrice
        self.brandName = brandName
        self.brandmodelName = brandmodelName
        self.emailId = emailId
        self.location = location
        self.latiTude = latiTude
        self.longiTude = longiTude
        self.productCondition = productCondition
        self.productCreated = productCreated
        self.productDesp = productDesp
        self.productId = productId
        self.productImage1 = productImage1
        self.productImage2 = productImage2
        self.productImage3 = productImage3
        self.productName = productName
        self.productPrice = productPrice
        self.productYear = productYear
        self.userId = userId
        self.userName = userName
    }

}
