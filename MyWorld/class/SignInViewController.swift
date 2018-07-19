//
//  SignInViewController.swift
//  MyWorld
//
//  Created by MyWorld on 04/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import GoogleSignIn

import SVProgressHUD
class SignInViewController: UIViewController ,GIDSignInUIDelegate,SWRevealViewControllerDelegate{
 @IBOutlet weak var signInButton: GIDSignInButton!
    
    var image = NSURL()
    @IBOutlet weak var txtEmailId: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    @IBAction func btnFacebook(_ sender: Any) {
        
         loginWithFB()
        
    }
    
    @IBAction func btnForgotPass(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //txtEmailId.text = "ranjeet@gmail.com"
        //txtPassword.text = "123456"
    }
 
    
    @IBAction func btnGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self;
        GIDSignIn.sharedInstance().signIn();
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            
        } else {
            
        }
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSignIn(_ sender: Any) {
    
        if Reachability.shared.isConnectedToNetwork(){
            if self.areAllFieldvalid() {
                 validateSignIn(emailId:txtEmailId.text!,password: txtPassword.text!,deviceId:UserDefaults.standard.string(forKey: "deviceToken") ?? "",tag: "ios")
                
            }
        
        }else{
            
            let alertController = UIAlertController(title: "My World", message: "Please check network", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnNotRegister(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    
    func validateSignIn(emailId: String,password: String,deviceId: String,tag: String) {
        SVProgressHUD.show(withStatus: "Loading")
        
        let emailId = emailId
        let password = password
        let deviceId = deviceId
        let tag = tag
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"signIn.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
       
        let paramString="device=ios"+"&emailId="+emailId+"&"+"password="+password+"&"+"deviceId="+deviceId+"&"+"tag="+tag
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                SVProgressHUD.dismiss()
                return
            }
            if let data = data {
                
                let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("***** \(String(describing: dataString))") //JSONSerialization
                
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                SVProgressHUD.dismiss()
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                 let checkcode1="201"
                if responseCode==checkcode{
                 DispatchQueue.main.async {
                
                 
                    let EmailId=Data["emailId"] as? String
                    let userId=Data["userId"] as? String
                    let firstName=Data["firstName"] as? String
                    let lastName=Data["lastName"] as? String
                    let mobileNo=Data["mobileNo"] as? String
                    let profileImage=Data["profileImage"] as? String
                    let coverImage=Data["coverImage"] as? String
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(EmailId, forKey: "EmailId")
                    userDefaults.set(userId, forKey: "userId")
                    userDefaults.set(firstName, forKey: "firstName")
                    userDefaults.set(lastName, forKey: "lastName")
                    userDefaults.set(mobileNo, forKey: "mobileNo")
                    userDefaults.set(profileImage, forKey: "profileImage")
                    userDefaults.set(coverImage, forKey: "coverImage")
                    userDefaults.synchronize()
                    
                    AppDelegate.getAppDelegate().openDashBoaerdController()
//                    let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let desCV = MainStoryboard.instantiateViewController(withIdentifier: "BottomViewController") as! BottomViewController
//                    self.navigationController?.pushViewController(desCV, animated: true)
//
                    
                }
               
                }else if responseCode==checkcode1 {
                     DispatchQueue.main.async {
                    let EmailId=Data["emailId"] as? String
                    let userId=Data["userId"] as? String
                    let otp=Data["otp"] as? String
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(EmailId, forKey: "EmailId")
                    userDefaults.set(userId, forKey: "userId")
                    userDefaults.set(otp, forKey: "otp")
                    userDefaults.synchronize()
                    
                    // Create the alert controller
                    let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyYourAccountViewController") as! VerifyYourAccountViewController
                        self.present(newViewController, animated: true, completion: nil)
                        
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                    
                    }
                    
                }else{
                    
                    DispatchQueue.main.async { // Correct
                    
                    let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                    
                }
             
            } catch let error as NSError {
                print(error)
                SVProgressHUD.dismiss()
            }
            
        }
        
        task.resume()
    }
   
    
    func loginWithFB(){
        SVProgressHUD.show(withStatus: "Please wait...")
        SKFacebookHelper.shared.login(sender: self) { (error, loginData) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error)
            }
            else{
                SVProgressHUD.show(withStatus: "Loading user details")
                
                SKFacebookHelper.shared.loadCurrentUser(completion: { (error, user) in
                    if error != nil{
                        SVProgressHUD.showError(withStatus: error)
                    }
                    else{
                        SVProgressHUD.dismiss()
                        
                        print(SKFacebookHelper.shared.fbUser?.id ?? "")
                        print(SKFacebookHelper.shared.fbUser?.name ?? "")
                        print(SKFacebookHelper.shared.fbUser?.profilePicUrl ?? "")
                        print(SKFacebookHelper.shared.fbUser?.email ?? "")
                        
                        let fullName = SKFacebookHelper.shared.fbUser?.name ?? ""
                        let emailId = SKFacebookHelper.shared.fbUser?.email ?? ""
                        self.image = (SKFacebookHelper.shared.fbUser?.profilePicUrl as NSURL?)!
                        print(">>>>>>>>>>",self.image)
                        let finalImage = self.image.absoluteString
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(finalImage, forKey: "profileImage")
                        userDefaults.synchronize()
                        
                        print("************",finalImage)
                        self.registerUserSocialMedia(fullName: fullName,emailId: emailId,imagef: finalImage!,deviceId: UserDefaults.standard.string(forKey: "deviceToken") ?? "")
                        
                        
                    }
                })
            }
        }
        
    }
    
    
    func registerUserSocialMedia(fullName:String,emailId:String,imagef:String,deviceId:String) {
        let urlToRequest = WEBSERVICE_URL+"registerUser.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString = "device=ios"+"&fullName="+fullName+"&"+"emailId="+emailId+"&"+"image="+imagef+"&"+"deviceId="+deviceId
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            if let data = data {
                DispatchQueue.main.async { // Correct
                    
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("***** \(String(describing: dataString))") //JSONSerialization
                    
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    DispatchQueue.main.async { // Correct
                        
                        let EmailId=Data["emailId"] as? String
                        let userId=Data["userId"] as? String
                        let firstName=Data["firstName"] as? String
                        let lastName=Data["lastName"] as? String
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(EmailId, forKey: "EmailId")
                        userDefaults.set(userId, forKey: "userId")
                        userDefaults.set(firstName, forKey: "firstName")
                        userDefaults.set(lastName, forKey: "lastName")
                        userDefaults.synchronize()
                        
                        
                        AppDelegate.getAppDelegate().openDashBoaerdController()

                    }
                }else{
                    
                    let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }
    
    
    func areAllFieldvalid() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if txtEmailId.text?.count == 0 {
            
           // AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter Your EmailId")
            
            let alertController = UIAlertController(title: "My World", message: "Please Enter Your EmailId", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        
            return false
            
        }else if txtPassword.text?.count == 0 {
            
            //AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter Your Password")
            
            let alertController = UIAlertController(title: "My World", message: "Please Enter Your Password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        return true
        
    }
    

   
}
