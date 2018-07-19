//
//  AdressList.swift
//  MyWorld
//
//  Created by MyWorld on 15/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class AdressLists: Codable{
    
    let addressList:[AdressList]
    
    init(addressList:[AdressList]) {
        self.addressList = addressList
    }
}

class AdressList: Codable {

    let add_type:String
    let addressId:String
    let city:String
    let country:String
    let defaultType:String
    let houseNo:String
    let landmark:String
    let mobileNo:String
    let pincode:String
    let state:String
    let street:String
    
    init(add_type:String,addressId:String,city:String,country:String,defaultType:String,houseNo:String,landmark:String,mobileNo:String,pincode:String,state:String,street:String){
        
        self.add_type = add_type
        self.addressId = addressId
        self.city = city
        self.country = country
        self.defaultType = defaultType
        self.houseNo = houseNo
        self.landmark = landmark
        self.mobileNo = mobileNo
        self.pincode = pincode
        self.state = state
        self.street = street
        
    }


}
