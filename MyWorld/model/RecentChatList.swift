//
//  RecentChatList.swift
//  MyWorld
//
//  Created by MyWorld on 22/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class RecentChat:Codable{
    let recentList:[RecentChatList]
    
    init(recentList:[RecentChatList]) {
        self.recentList = recentList
    }
}

class RecentChatList: Codable {
    
    
    let emailId:String
    let firstName:String
    let lastName:String
    let onlineFlag:String
    let profileImage:String
    let userId:String
    let userName:String
    
    init(emailId:String,firstName:String,lastName:String,onlineFlag:String,profileImage:String,userId:String,userName:String) {
       
        self.emailId = emailId
        self.firstName = firstName
        self.lastName = lastName
        self.onlineFlag = onlineFlag
        self.profileImage = profileImage
        self.userId = userId
        self.userName = userName
    }

}
