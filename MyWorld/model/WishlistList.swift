//
//  WishlistList.swift
//  MyWorld
//
//  Created by MyWorld on 14/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class WishlistLists :Codable{
    
    let productlist: [WishlistList]
    
    init(productlist: [WishlistList])
    {
        self.productlist = productlist
    }
}

class WishlistList: Codable {
    
    
    let Percent:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let userName:String
    let wishId:String
    
    init(Percent:String,productId:String,productImage1:String,productName:String,productPrice:String,userName:String,wishId:String){
        self.Percent = Percent
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.userName = userName
        self.wishId = wishId
        
    }

}
