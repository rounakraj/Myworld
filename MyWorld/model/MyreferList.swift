//
//  MyreferList.swift
//  MyWorld
//
//  Created by MyWorld on 29/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class MyreferLists: Codable{
    
    let referList: [MyreferList]
    init(referList: [MyreferList]) {
        self.referList = referList
    }
}

class MyreferList: Codable {

    let Points:String
    let firstName:String
    
    init(Points:String,firstName:String)
    {
        self.Points = Points
        self.firstName = firstName
    }
    
}
