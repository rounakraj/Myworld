//
//  HistoryOrderList.swift
//  MyWorld
//
//  Created by MyWorld on 06/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
class HistoryOrderLists:Codable{

    let orderList:[HistoryOrderList]
    init(orderList:[HistoryOrderList]) {
        self.orderList = orderList
    }
}
class HistoryOrderList: Codable {

    let ProductsplPrice:String
    let city:String
    let country:String
    let deliveredDate:String
    let dispatchDate:String
    let houseNo:String
    let landmark:String
    let orderCreated:String
    let orderDate:String
    let orderId:String
    let orderQuantity:String
    let orderStatus:String
    let paymentType:String
    let pincode:String
    let processingDate:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let shippingDate:String
    let state:String
    let street:String
    
 init(ProductsplPrice:String,city:String,country:String,deliveredDate:String,dispatchDate:String,houseNo:String,landmark:String,orderCreated:String,orderDate:String,orderId:String,orderQuantity:String,orderStatus:String,paymentType:String,pincode:String,processingDate:String, productId:String,productImage1:String,productName:String,productPrice:String,shippingDate:String,state:String,street:String) {
        
    
        self.ProductsplPrice = ProductsplPrice
        self.city = city
        self.country = country
        self.deliveredDate = deliveredDate
        self.dispatchDate = dispatchDate
        self.houseNo = houseNo
        self.landmark = landmark
        self.orderCreated = orderCreated
        self.orderDate = orderDate
        self.orderId = orderId
        self.orderQuantity = orderQuantity
        self.orderStatus = orderStatus
        self.paymentType = paymentType
        self.pincode = pincode
        self.processingDate = processingDate
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.shippingDate = shippingDate
        self.state = state
        self.street = street
    }


}
