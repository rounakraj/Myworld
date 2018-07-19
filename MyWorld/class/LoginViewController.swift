//
//  LoginViewController.swift
//  MyWorld
//
//  Created by MyWorld on 04/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import GoogleSignIn
import SVProgressHUD
import SwiftQRScanner


class LoginViewController: UIViewController ,GIDSignInUIDelegate,SWRevealViewControllerDelegate,QRScannerCodeDelegate{
    @IBOutlet weak var signInButton: GIDSignInButton!

    var image = NSURL()
    let scanner = QRCodeScannerController()
    @IBAction func btnScanner(_ sender: Any) {

        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
    
    func qrCodeScanningDidCompleteWithResult(result: String) {
        print("result:\(result)")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        newViewController.ReferalCode = result
        self.navigationController?.pushViewController(newViewController, animated: true)
        
        scanner.dismisAction()
    }
    
    func qrCodeScanningFailedWithError(error: String) {
        print("error:\(error)")
        scanner.dismisAction()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  (UserDefaults.standard.string(forKey:"userId" ) != nil) {
            AppDelegate.getAppDelegate().openDashBoaerdController()
        }
        GIDSignIn.sharedInstance().uiDelegate = self
          // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true

    }
    @IBAction func loginFacebook(_ sender: Any) {
    loginWithFB()
    }
    @IBAction func loginGoogle(_ sender: Any) {
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
    
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(desCV, animated: true)
        
        
    }
    
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(desCV, animated: true)
        
       
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
                        self.registerUserSocialMedia(fullName: fullName,emailId: emailId,imagef: finalImage!,deviceId:         UserDefaults.standard.string(forKey: "deviceToken") ?? ""
)
                       
                        
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
        let paramString="device=ios"+"&fullName="+fullName+"&"+"emailId="+emailId+"&"+"image="+imagef+"&"+"deviceId="+deviceId
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
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
   
    func found(code: String) {
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
   
}
