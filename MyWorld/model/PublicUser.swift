//
//  PublicUser.swift
//  MyWorld
//
//  Created by MyWorld on 05/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class PublicUsers:Codable{
    
    let User:[PublicUser]
    
    init(User:[PublicUser]) {
        self.User = User
    }
    
}


class PublicUser: Codable {

    let emailId:String
    let firstName:String
    let lastName:String
    let mobileNo:String
    let onlineFlag:String
    let profileImage:String
    let userId:String
    let userStatus:String
    
    init(emailId:String,firstName:String,lastName:String,mobileNo:String,onlineFlag:String,profileImage:String,userId:String,userStatus:String) {
        
        self.emailId = emailId
        self.firstName = firstName
        self.lastName = lastName
        self.mobileNo = mobileNo
        self.onlineFlag = onlineFlag
        self.profileImage = profileImage
        self.userId = userId
        self.userStatus = userStatus
    }
    
}
