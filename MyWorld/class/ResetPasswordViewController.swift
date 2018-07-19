//
//  ResetPasswordViewController.swift
//  MyWorld
//
//  Created by MyWorld on 11/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBAction func backPress(_ sender: Any) {
        
          navigationController?.popViewController(animated:true)
    }
    
    @IBOutlet weak var txtEnterNewPass: UITextField!
    
    @IBOutlet weak var txtReEnterPass: UITextField!
    
    @IBOutlet weak var txtEnterOtp: UITextField!
    
    @IBOutlet weak var lblCounter: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnSubmit(_ sender: Any) {
        
        if Reachability.shared.isConnectedToNetwork(){
            if self.areAllFieldvalid() {
                let otp = UserDefaults.standard.value(forKey: "otp") as! String
                ResetPassword(otp: otp)
            }
            
        }else{
            
            let alertController = UIAlertController(title: "My World", message: "Please check network", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func ResetPassword(otp:String) -> Void {
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        let postData = NSMutableData(data: "emailId=\(String(describing: otp))".data(using: String.Encoding.utf8)!)
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "resetPassword.php", uiView: self.view, withCompletionHandler: {data,error in
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
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let Otp = UserDefaults.standard.value(forKey: "otp") as! String
        if txtEnterNewPass.text?.count == 0 {
            
            // AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter New Password")
            
            let alertController = UIAlertController(title: "My World", message: "Please Enter New Password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }else if txtReEnterPass.text?.count == 0 {
            
            //AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter Re-Password")
            
            let alertController = UIAlertController(title: "My World", message: "Please Enter Your Password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }else if txtEnterOtp.text?.count == 0 {
            
            //AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter otp")
            
            let alertController = UIAlertController(title: "My World", message: "Please Enter Your OTP", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }else if txtEnterOtp.text != Otp {
            
            //AlertManager.showAlert(targetVC: self, title: "Message", message: "Please Enter otp")
            
            let alertController = UIAlertController(title: "My World", message: "Please Enter Your OTP", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        return true
        
    }

}
