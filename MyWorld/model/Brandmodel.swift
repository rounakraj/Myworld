//
//  Brandmodel.swift
//  MyWorld
//
//  Created by MyWorld on 27/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class BrandmodelList: Codable{
    
    let model: [Brandmodel]
    
    init(model: [Brandmodel]){
        self.model = model
    }
    
}

class Brandmodel: Codable {
    
    let brandmodelId:String
    let brandmodelName:String
    
    
    init(brandmodelId:String,brandmodelName:String){
        self.brandmodelId = brandmodelId
        self.brandmodelName = brandmodelName
    }
}
