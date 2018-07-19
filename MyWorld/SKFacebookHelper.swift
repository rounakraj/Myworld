//
//  DKFacebookHelper.swift
//  Update
//
//  Created by S Kumar on 12/12/17.
//  Copyright © 2017 Shankar Kumar. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import FacebookShare

class FBLoginData {
    var token : String?
    var grantedPermission : Set<Permission>?
    var declinePermission : Set<Permission>?
    var accessToken : AccessToken?
    var appId : String?
    var userId : String?
}


class SKFacebookUser {
    var id : String?
    var name : String?
    var email : String?
    var gender : String?
    var relationship_status : String?
    var dob : String?

    var profilePicUrl : URL{
        get{
            return URL(string: "https://graph.facebook.com/\(SKFacebookHelper.shared.fbUser?.id ?? "")/picture?width=9999")!
        }
    }
}
class SKFacebookHelper {
    // MARK: - Shared Instance
    static let shared : SKFacebookHelper = {
        let instance = SKFacebookHelper()
        return instance
    }()
   
    // MARK: - Properties
    var loginData : FBLoginData?
    var fbUser : SKFacebookUser?
    let permission : [ReadPermission] = [.publicProfile,.email,.userAboutMe]
    let parameters = ["fields" : "id,name,email,birthday,gender"]
    
    
    // MARK: - Methods
    func login(sender : UIViewController, completion : @escaping (_ error : String?, _ loginData : FBLoginData?)->Void){
        let loginManager = LoginManager()
        loginManager.loginBehavior = .systemAccount
        
        loginManager.logIn(readPermissions: permission, viewController: sender) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                completion(error.localizedDescription,nil)
                return
            case .cancelled:
                completion("User cancelled login.",nil)
                return
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let logindata = FBLoginData()
                logindata.grantedPermission = grantedPermissions
                logindata.declinePermission = declinedPermissions
                logindata.accessToken = accessToken
                logindata.token = accessToken.authenticationToken
                logindata.appId = accessToken.appId
                logindata.userId = accessToken.userId
                self.loginData = logindata
                completion(nil,logindata)
                return
            }
        }
        
    }
    func loadCurrentUser(completion : @escaping (_ error : String?, _ user : SKFacebookUser?)->Void){
      
        //let params = ["fields" : "email, name"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: parameters)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                completion(error.localizedDescription,nil)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    let user = setupFacebookUserFromResponce(responseDictionary)
                    self.fbUser = user
                    completion(nil,user)
                }
                else{
                    completion("Details not found",nil)
                }
            }
        }
        func setupFacebookUserFromResponce(_ responseObject : [String : Any]) -> SKFacebookUser{
            let name : String? = responseObject["name"] as? String
            let id : String? = responseObject["id"] as? String
            let email : String? = responseObject["email"] as? String
            //let albums : [String : Any]? = responseObject["albums"] as? Dictionary
            let gender : String? = responseObject["gender"] as? String
            let birthday : String? = responseObject["birthday"] as? String
            
            let user = SKFacebookUser()
            user.name = name
            user.id = id
            user.gender = gender
            user.dob = birthday
            user.email = email

            return user
        }
    }
    
}
