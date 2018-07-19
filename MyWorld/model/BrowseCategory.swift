//
//  BrowseCategory.swift
//  MyWorld
//
//  Created by MyWorld on 12/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class BrowseCategorys: Codable{
    let categorylist:[BrowseCategory]
    init(categorylist:[BrowseCategory])
    {
        self.categorylist=categorylist
    }
}


class BrowseCategory: Codable {

    let catId:String
    let catImage:String
    let catName:String
    
    init(catId: String,catImage: String, catName: String)
    {
        self.catId = catId
        self.catImage = catImage
        self.catName = catName
    }
    
}
