//
//  ResourceBrandList.swift
//  MyWorld
//
//  Created by MyWorld on 27/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class ResourceBrandLists: Codable{
    
    let brand: [ResourceBrandList]
    init(brand: [ResourceBrandList]) {
        self.brand = brand
    }
    
}

class ResourceBrandList: Codable {
    
    let brandId:String
    let brandName:String
    init(brandId:String,brandName:String) {
        self.brandId = brandId
        self.brandName = brandName
    }

}
