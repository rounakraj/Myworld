//
//  BrandList.swift
//  MyWorld
//
//  Created by Bhupesh Kathuria on 27/12/17.
//  Copyright © 2017 Bhupesh Kathuria. All rights reserved.
//

import UIKit

class BrandLists:Codable{
    
    let brand:[BrandList]
    
    init(brand:[BrandList]) {
        self.brand = brand
    }
}



class BrandListModel: Codable {

    let brandId:String
    let brandName:String

    init(brandId:String,brandName:String) {
        self.brandId = brandId
        self.brandName = brandName
    }
    
   
}
