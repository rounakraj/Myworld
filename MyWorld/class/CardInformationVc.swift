//
//  CardInformationVc.swift
//  MyWorld
//
//  Created by Shankar Kumar on 11/02/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD
import InstaMojoiOS

class CardInformationVc: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDesc: UITextField!

    var StringBuilder = String()
    var StringBuilder1 = String()
    var price = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstName = UserDefaults.standard.value(forKey: "firstName") as! String
        let emailId = UserDefaults.standard.value(forKey: "EmailId") as! String

        txtPrice.text = PaymentDetailData.shared.totalPrice
        txtEmail.text = emailId
        txtName.text = firstName
        let string = NSString(string: PaymentDetailData.shared.totalPrice ?? "")
        
        if string.doubleValue > 10000 {
            txtPrice.text = "10000"
        }else if string.doubleValue < 10 {
            txtPrice.text = "10"
        }
    }
    @IBAction func backAction(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func payAction(_ sender: Any) {
        
        if Reachability.shared.isConnectedToNetwork(){
            if self.areAllFieldvalid() {
                
                IMConfiguration.sharedInstance.setupOrder(purpose: "MYwordl", buyerName: txtName.text!, emailId: txtEmail.text!, mobile: txtMobile.text!, amount: txtPrice.text!, environment: .Production, on: self) { (success, message) in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        if success {
                            self.showAlertViewWithTitle(title: "Message", message: message)

                        } else {
                            self.showAlertViewWithTitle(title: "Message", message: message)

                        }
                    })
                }

            }
            
        }else{
            
            let alertController = UIAlertController(title: "My World", message: "Please check network", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
    }
    
    func areAllFieldvalid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if txtName.text?.count == 0 {
            SVProgressHUD.showInfo(withStatus: "Please enter name")
            return false
        }else if txtEmail.text?.count == 0 {
            SVProgressHUD.showInfo(withStatus: "Please enter email")
            return false
        }else if txtMobile.text?.count == 0 {
            SVProgressHUD.showInfo(withStatus: "Please enter mobile")
            return false
        }else if (txtMobile.text?.count)! < 10 {
            SVProgressHUD.showInfo(withStatus: "Please enter valid mobile")
            return false
        }else if !emailTest.evaluate(with: txtEmail.text) {
            SVProgressHUD.showInfo(withStatus: "Please enter valid email")
            return false
        }else if txtDesc.text?.count == 0 {
            SVProgressHUD.showInfo(withStatus: "Please enter valid description")

            return false
        }
        
        return true
    }
    func showAlertViewWithTitle(title : String,message:String) -> Void {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.navigationController?.popToRootViewController(animated:true)

        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
   
    

}
