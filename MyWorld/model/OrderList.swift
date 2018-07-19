//
//  OrderList.swift
//  MyWorld
//
//  Created by MyWorld on 05/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class OrderLists:Codable{
    let orderList:[OrderList]
    init(orderList:[OrderList]){
        self.orderList = orderList
    }
}


class OrderList: Codable {
    

    let orderDate:String
    let orderQuantity:String
    let orderStatus:String
    let paymentType:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let productsplPrice:String
    
    init(orderDate:String,orderQuantity:String,orderStatus:String,paymentType:String,productId:String,productImage1:String,productName:String,productPrice:String,productsplPrice:String) {
        
        self.orderDate = orderDate
        self.orderQuantity = orderQuantity
        self.orderStatus = orderStatus
        self.paymentType = paymentType
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.productsplPrice = productsplPrice
    }

}
