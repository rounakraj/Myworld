//
//  SimilarList.swift
//  MyWorld
//
//  Created by MyWorld on 05/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit


class SimilarLists:Codable{
    
    let similarList:[SimilarList]
    init(similarList:[SimilarList]) {
        self.similarList = similarList
    }
}


class SimilarList: Codable {

    let Percent:String
    let ProductsplPrice:String
    let productId:String
    let productImage1:String
    let productName:String
    let productPrice:String
    let userName:String
    
init(Percent:String,ProductsplPrice:String,productId:String,productImage1:String,productName:String,productPrice:String,userName:String) {
        
        self.Percent = Percent
        self.ProductsplPrice = ProductsplPrice
        self.productId = productId
        self.productImage1 = productImage1
        self.productName = productName
        self.productPrice = productPrice
        self.userName = userName
    }

}
