//
//  Categorylist.swift
//  MyWorld
//
//  Created by MyWorld on 26/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class Categorylists: Codable{
    let categorylist:[Categorylist]
    init(categorylist:[Categorylist]) {
        self.categorylist = categorylist
    }
}

class Categorylist: Codable {

    
    let catId:String
    let catImage:String
    let catName:String
    
    init(catId:String,catImage:String,catName:String) {
        self.catId = catId
        self.catImage = catImage
        self.catName = catName
    }
}
