//
//  NewProductList.swift
//  MyWorld
//
//  Created by MyWorld on 14/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class NewList:Codable{
    
    let productAll:[NewProductList]
    
    init(productAll:[NewProductList]) {
        
        self.productAll = productAll
    }
    
}

class NewProductList: Codable {
    
    let Percent:String
    let productCreated:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let userName:String
    
    init(Percent:String,productCreated:String,productId:String,productImage1:String,productName:String,productPrice:String,userName:String){
        
        self.Percent = Percent
        self.productCreated = productCreated
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.userName = userName
        
        
        
    }

}
