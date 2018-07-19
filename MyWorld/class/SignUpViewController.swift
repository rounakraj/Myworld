//
//  SignUpViewController.swift
//  MyWorld
//
//  Created by MyWorld on 04/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import GoogleSignIn
import SVProgressHUD
class SignUpViewController: UIViewController ,GIDSignInUIDelegate,SWRevealViewControllerDelegate{
    
     @IBOutlet weak var signInButton: GIDSignInButton!
    var image = NSURL()
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPasword: UITextField!
    @IBOutlet weak var txtEmaiId: UITextField!
    @IBOutlet weak var txtReferalCode: UITextField!
    var ReferalCode = String()
    var isAccept = false
    
    
    //@IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    
    @IBAction func btnFacebook(_ sender: Any) {
        
         loginWithFB()
    }
    
    @IBAction func btnTermsCondition(_ sender: UIButton) {
    
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "TermsConditonViewController") as! TermsConditonViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    
    @IBAction func checkAction(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "checkbox") {
            sender.setImage(#imageLiteral(resourceName: "checkedbox"), for: .normal)
            isAccept = true
        }else{
            sender.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)
            isAccept = false
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    
        if ReferalCode.isEmpty{
             txtReferalCode.isHidden = true
        }else{
             txtReferalCode.isHidden = false
            txtReferalCode.text = ReferalCode
        }
       
        
    }
    

    @IBAction func btnGoogle(_ sender: Any) {
        
        GIDSignIn.sharedInstance().uiDelegate = self;
        GIDSignIn.sharedInstance().signIn();
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
    
    
    @IBAction func btnHaveAnAccount(_ sender: Any) {
        
    
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    
    @IBAction func btnRegister(_ sender: Any) {
        
        
        
        if Reachability.shared.isConnectedToNetwork(){
            
            if self.areAllFieldvalid() {
                
                validateSinup(firstName: txtFirstName.text!,lastName: txtLastName.text!,emailId: txtEmaiId.text!,password: txtPasword.text!,deviceId: "123",referCode: "",anotherCode: "",tag: "ios")
            }
            
        }else{
            
            let alertController = UIAlertController(title: "My World", message: "Please check network", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func validateSinup(firstName: String,lastName: String,emailId:String,password: String,deviceId: String,referCode: String,anotherCode: String,tag: String) {
        
        let firstName = firstName
        let lastName = lastName
        let emailId = emailId
        let password = password
        let deviceId = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        let referCode = referCode
        let anotherCode = ReferalCode
        let tag = tag
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"signUp.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="device=ios"+"&firstName="+firstName+"&"+"lastName="+lastName+"&"+"emailId="+emailId+"&"+"password="+password+"&"+"deviceId="+deviceId+"&"+"referCode="+referCode+"&"+"anotherCode="+anotherCode+"&"+"tag"+tag
        
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
                    //self.activityindicator.stopAnimating();
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let EmailId=Data["emailId"] as? String
                    let userId=Data["userId"] as? String
                    let otp=Data["otp"] as? String
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(EmailId, forKey: "EmailId")
                    userDefaults.set(userId, forKey: "userId")
                    userDefaults.set(otp, forKey: "otp")
                    userDefaults.synchronize()
                    
                    DispatchQueue.main.async {
                        
                        // Create the alert controller
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                        
                        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "VerifyYourAccountViewController") as! VerifyYourAccountViewController
                        self.navigationController?.pushViewController(desCV, animated: true)
                    
                    
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
        
        
        
        if txtFirstName.text?.count == 0 {
            
            //AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter First Name")
            let alertController = UIAlertController(title: "My World", message: "Please Enter First Name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }else if txtLastName.text?.count == 0 {
            
            //AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter Mobile Number")
            let alertController = UIAlertController(title: "My World", message: "Please Enter Last Name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return false
            
        }else if txtEmaiId.text?.count == 0 {
            
            //AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter Email")
            
            let alertController = UIAlertController(title: "My World", message: "Please Enter Email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return false
            
        }else if !emailTest.evaluate(with: txtEmaiId.text) {
            
            //AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter Valid Email")
            
            let alertController = UIAlertController(title: "My World", message: "Please Enter Valid Email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }else if txtPasword.text?.count == 0 {
            
            //AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter Email")
            
            let alertController = UIAlertController(title: "My World", message: "Please Enter Password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return false
            
        }
        if !isAccept {
            let alertController = UIAlertController(title: "My World", message: "Please accept terms & condition", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
        
    }
    
   
    

}
