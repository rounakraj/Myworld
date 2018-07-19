//
//  FriendRequest.swift
//  MyWorld
//
//  Created by MyWorld on 11/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
class FriendRequests: Codable {
    
    let friendRequest:[FriendRequest]
    init(friendRequest:[FriendRequest]) {
        self.friendRequest = friendRequest
    }
}
class FriendRequest: Codable {

    let firstName:String
    let lastName:String
    let mobileNo:String
    let profileImage:String
    let userId:String
    let userName:String
}
