//
//  OnlineFriends.swift
//  MyWorld
//
//  Created by MyWorld on 09/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class OnlineFriend:Codable{
    
    let friendList:[OnlineFriends]
    init(friendList:[OnlineFriends]){
        self.friendList = friendList
    }
}

class OnlineFriends: Codable {

    let emailId:String
    let firstName:String
    let followingStatus:String
    let lastName:String
    let mobileNo:String
    let onlineFlag:String
    let profileImage:String
    let userId:String
    let userStatus:String
    
    init(emailId:String,firstName:String,followingStatus:String,lastName:String,mobileNo:String,onlineFlag:String,profileImage:String,userId:String,userStatus:String){
        
        self.emailId = emailId
        self.firstName = firstName
        self.followingStatus = followingStatus
        self.lastName = followingStatus
        self.mobileNo = mobileNo
        self.onlineFlag = onlineFlag
        self.profileImage = profileImage
        self.userId = userId
        self.userStatus = userStatus
        
    }
    
}
