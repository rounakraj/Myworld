//
//  CartList.swift
//  MyWorld
//
//  Created by MyWorld on 01/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class CartLists:Codable{
    
    let cartList:[CartList]
    init(cartList:[CartList]) {
        self.cartList = cartList
    }
}
class CartList: Codable {

    let cartId:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let productsplPrice:String
    let quantity:String
    let singlePrice:String
    let singlesplPrice:String
    let userName:String
    
    init(cartId:String,productId:String,productImage1:String,productName:String,productPrice:String,productsplPrice:String,quantity:String,singlePrice:String,singlesplPrice:String,userName:String) {
        
        
        self.cartId = cartId
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.productsplPrice = productsplPrice
        self.quantity = quantity
        self.singlePrice = singlePrice
        self.singlesplPrice = singlesplPrice
        self.userName = userName
    }
}
