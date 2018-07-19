//
//  GlobaleArray.swift
//  MyWorld
//
//  Created by MyWorld on 14/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class GlobaleArrays: NSObject{
    
    let array:[GlobaleArray]
    init(array:[GlobaleArray]){
        self.array = array
    }
}

class GlobaleArray: NSObject {

    let Percent:String
    let productId :String
    let productImage1:String
    let productName:String
    let productPrice:String
    let productsplPrice:String
    let noTrending:String
    let userName:String
    
    init(Percent:String,productId :String,productImage1:String,productName:String,productPrice:String,productsplPrice:String,noTrending:String,userName:String){
        
        self.Percent = Percent
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.productsplPrice = productsplPrice
        self.noTrending = noTrending
        self.userName = userName
        
    }
}
