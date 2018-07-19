//
//  NotificationData.swift
//  Haultips
//
//  Created by Alivenet Solution on 19/09/17.
//  Copyright © 2017 Alivenet Solution. All rights reserved.
//

import UIKit
protocol NotificationDelegate {
    func goToNotificationDetail(controller:UIViewController)
    
}
class NotificationData: NSObject {
    var data:NSDictionary? = nil
    var type:String = ""
    var delegate: NotificationDelegate? = nil
    
    static let sharedInstance : NotificationData = {
        let instance = NotificationData()
        return instance
    }()
    
    
    func setData(data:NSDictionary){
        self.data = data
        self.type = self.data?.value(forKey:"type") as! String
        print("notification data assigned", self.data as Any!)
    }
    
    func openController(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        if delegate != nil{
            
            if self.type == "Get Offer" {
                
                
            }else if self.type == "New Question"{
                //let vc = storyboard.instantiateViewController(withIdentifier: "QuestionAnsware") as! QuestionAnsware
                
                //delegateNotification?.goToNotificationDetail(controller: vc)
                
                
            }else if self.type == "Get Answer"{
                
                
            }else if self.type == ""{
                
            }else if self.type == ""{
                
            }
        }
    }
}
