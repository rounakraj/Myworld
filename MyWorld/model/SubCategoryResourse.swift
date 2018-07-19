//
//  SubCategoryResourse.swift
//  MyWorld
//
//  Created by MyWorld on 13/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class SubCategoryResourseList: Codable{
    
    let subcategory:[SubCategoryResourse]
    
    init(subcategory:[SubCategoryResourse]){
        self.subcategory = subcategory
    }
}

class SubCategoryResourse: Codable {

    let subcatId: String
    let subcatName: String
    
    init(subcatId: String, subcatName: String) {
        self.subcatId = subcatId
        self.subcatName = subcatName
    }
    

}
