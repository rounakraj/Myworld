//
//  Subcategory.swift
//  MyWorld
//
//  Created by MyWorld on 26/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class SubcategoryLists:Codable{
    
    let subcategory: [Subcategory]
    init(subcategory: [Subcategory]) {
        self.subcategory = subcategory
    }
}

class Subcategory: Codable {

    let subcatId:String
    let subcatName:String
    init(subcatId:String,subcatName:String) {
        self.subcatId = subcatId
        self.subcatName = subcatName
    }

}
