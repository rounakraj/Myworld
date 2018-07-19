//
//  BrowesSubCatList.swift
//  MyWorld
//
//  Created by MyWorld on 13/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class BrowesSubCatLists1: Codable{
    
    let productServer:[BrowesSubCatList]
    init(productServer:[BrowesSubCatList]){
        self.productServer = productServer
    }
}
class BrowesSubCatLists2: Codable{
    
    let productUser:[BrowesSubCatList]
    init(productUser:[BrowesSubCatList]){
        self.productUser = productUser
    }
}

class BrowesSubCatLists3: Codable{
    
    let productAll:[BrowesSubCatList]
    init(productAll:[BrowesSubCatList]){
        self.productAll = productAll
    }
}

class BrowesSubCatList: Codable {

    
    let Percent:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let userName:String
    
    init(Percent:String,productId:String,productImage1:String,productName:String,productPrice:String,userName:String)
    {
        self.Percent = Percent
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.userName = userName
    }
}
