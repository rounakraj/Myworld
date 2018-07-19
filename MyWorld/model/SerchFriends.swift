//
//  SerchFriends.swift
//  MyWorld
//
//  Created by MyWorld on 29/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class SerchFriend:Codable{
    let User:[SerchFriends]
    init(User:[SerchFriends]){
        self.User = User
    }
}

class SerchFriends: Codable {

    let emailId:String
    let firstName:String
    let lastName:String
    let mobileNo:String
    let onlineFlag:String
    let profileImage:String
    let userId:String
    let userStatus:String
    let IsInVited:String
    
    init (emailId:String,firstName:String,lastName:String,mobileNo:String,onlineFlag:String,profileImage:String,userId:String,userStatus:String,IsInVited:String)
    {
        self.emailId = emailId
        self.firstName = firstName
        self.lastName = lastName
        self.mobileNo = mobileNo
        self.onlineFlag = onlineFlag
        self.profileImage = profileImage
        self.userId = userId
        self.userStatus = userStatus
        self.IsInVited = IsInVited
    }

}
