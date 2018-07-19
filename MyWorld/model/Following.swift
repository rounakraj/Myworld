//
//  Following.swift
//  MyWorld
//
//  Created by MyWorld on 11/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
class Followings:Codable{
    let FollowingList:[Following]
    init(FollowingList:[Following]) {
        self.FollowingList = FollowingList
    }
}

class Follwer: Codable {
    let followersList:[Following]
    init(followersList:[Following]) {
        self.followersList = followersList
    }
}

class Following: Codable {
    
    let firstName:String
    let lastName:String
    let mobileNo:String
    let profileImage:String
    let userId:String
    let userStatus:String
    
    init(firstName:String,lastName:String,mobileNo:String,profileImage:String,userId:String,userStatus:String) {
        self.firstName  = firstName
        self.lastName = lastName
        self.mobileNo = mobileNo
        self.profileImage  = profileImage
        self.userId = userId
        self.userStatus = userStatus
    }

}
