//
//  ForgotPassViewController.swift
//  MyWorld
//
//  Created by MyWorld on 11/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class ForgotPassViewController: UIViewController {
    @IBOutlet weak var txtEnterEmail: UITextField!
    
    @IBAction func btnbackPress(_ sender: Any) {
         navigationController?.popViewController(animated:true)
    }
    @IBAction func btnResetPassword(_ sender: Any) {
        
        if Reachability.shared.isConnectedToNetwork(){
            if self.areAllFieldvalid() {
                ForgetPassword(emailId:txtEnterEmail.text!)
                
            }
            
        }else{
            
            let alertController = UIAlertController(title: "My World", message: "Please check network", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func ForgetPassword(emailId:String) -> Void {
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        let postData = NSMutableData(data: "emailId=\(String(describing: emailId))".data(using: String.Encoding.utf8)!)
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "forgetPassword.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                DispatchQueue.main.async(execute: {
                    actInd.stopAnimating()
                    actInd.removeFromSuperview()
                    
                    let alertController = UIAlertController(title: "MyWorld", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        // Do whatever you want with inputTextField?.text
                        
                    })
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                })
                
            }else{
                
                print(data);
                
                if data.value(forKey: "responseCode") as! String == "200"{
                    DispatchQueue.main.async(execute: {
                        
                        let value: AnyObject? = data.value(forKey: "statusList") as AnyObject
                        
                        if value is NSString {
                            print("It's a string")
                            
                        } else if value is NSArray {
                            print("It's an NSArray")
                            //self.shareUpdateArray = value as! NSArray
                            
                        }
                         let userDefaults = UserDefaults.standard
                        userDefaults.set(data.value(forKey: "emailId") as! String, forKey: "EmailId")
                        userDefaults.set(data.value(forKey: "userId") as! String, forKey: "userId")
                        userDefaults.set(data.value(forKey: "otp") as! String, forKey: "otp")
                        
                        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                        self.navigationController?.pushViewController(desCV, animated: true)
                        
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        let alertController = UIAlertController(title: "MyWorld", message: data .value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            // Do whatever you want with inputTextField?.text
                            
                        })
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    })
                }
                
            }
            
        })
    }

    
    func areAllFieldvalid() -> Bool {
        
        if txtEnterEmail.text?.count == 0 {
            
            // AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter Your EmailId")
            
            let alertController = UIAlertController(title: "My World", message: "Please Enter Your EmailId", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        return true
        
    }
}
