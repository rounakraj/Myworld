//
//  FutureBrand.swift
//  MyWorld
//
//  Created by MyWorld on 12/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class BrandList:Codable{
    
    let brandList:[FutureBrand]
    
    init(brandList: [FutureBrand]) {
        self.brandList = brandList
    }
}

class FutureBrand: Codable {
    
    let brandImage: String
    let brandName: String
    let featureId: String
    
    init(brandImage:String,brandName:String,featureId:String) {
        self.brandImage=brandImage
        self.brandName=brandName
        self.featureId=featureId
    }
    
    

}
