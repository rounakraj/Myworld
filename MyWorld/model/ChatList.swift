//
//  ChatList.swift
//  MyWorld
//
//  Created by MyWorld on 24/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class ChatLists:Codable{
    
    let chatList: [ChatList]
    init(chatList: [ChatList]){
        self.chatList = chatList
    }
}

class ChatList: Codable {
    
    let chatDate:String
    let chatFile:String
    let chatFlag:String
    let chatMsg:String
    let chatTime:String
    
    init(chatDate:String,chatFile:String,chatFlag:String,chatMsg:String,chatTime:String) {
        self.chatDate = chatDate
        self.chatFile = chatFile
        self.chatFlag = chatFlag
        self.chatMsg = chatMsg
        self.chatTime = chatTime
    }

}
