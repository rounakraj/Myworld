//
//  FriendsResourse.swift
//  MyWorld
//
//  Created by MyWorld on 12/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit


class Friends: Codable{
    let friendList:[FriendsResourse]
    
    init(friendList: [FriendsResourse]) {
        self.friendList = friendList
    }
    
}

class FriendsResourse: Codable {

    let emailId: String
    let firstName: String
    let followingStatus: String
    let lastName: String
    let mobileNo: String
    let onlineFlag: String
    let profileImage: String
    let userId: String
    let userStatus: String
    
    init(emailId:String,firstName: String,followingStatus:String,lastName:String,mobileNo:String,onlineFlag:String,profileImage:String,userId:String,userStatus:String) {
        self.emailId=emailId
        self.firstName=firstName
        self.lastName=lastName
        self.followingStatus=followingStatus
        self.mobileNo=mobileNo
        self.onlineFlag=onlineFlag
        self.profileImage=profileImage
        self.userId=userId
        self.userStatus=userStatus
        
        
    }
}
