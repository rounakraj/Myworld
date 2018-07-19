//
//  AddAdressViewController.swift
//  MyWorld
//
//  Created by MyWorld on 15/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddAdressViewController: UIViewController {
    @IBOutlet weak var txtMobileFiled: UITextField!
    @IBOutlet weak var txtHouseNo: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtLandmark: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var checkbox: UIButton!
    var conectUrl = ""
    var addType = ""
    var mobileNo = String()
    var HouseNo = String()
    var Landmark = String()
    var City = String()
    var State = String()
    var Country = String()
    var Pincode = String()
    var AddressId = String()
    var DefaultType = String()
    
    var checkedimage = UIImage(named: "checkedbox")
    var Uncheckedimage = UIImage(named: "checkbox")
    
    var isBoxclickde:Bool!
    
    
    @IBAction func btnCheckBox(_ sender: Any) {
        
        print()
        
        if isBoxclickde == true{
            isBoxclickde = false
        }else{
            isBoxclickde = true
        }
        if isBoxclickde == true{
            
            checkbox.setImage(checkedimage, for: UIControlState.normal)
            addType = "1"
        }else{
            addType = "0"
             checkbox.setImage(Uncheckedimage, for: UIControlState.normal)
        }
        print(addType)
    }
    
    
    @IBAction func backPressButton(_ sender: Any) {
        
        navigationController?.popViewController(animated:true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isBoxclickde = false
  
        
        if AddressId.isEmpty{
            conectUrl = WEBSERVICE_URL+"addAddress.php"
        }else{
            self.txtMobileFiled.text = mobileNo
            self.txtHouseNo.text = HouseNo
            self.txtStreet.text = Landmark
            self.txtLandmark.text = Landmark
            self.txtCity.text = City
            self.txtState.text = State
            self.txtCountry.text = Country
            self.txtPincode.text = Pincode
            
            if DefaultType == "1"
            {
                checkbox.setImage(checkedimage, for: UIControlState.normal)
                addType = "1"
               isBoxclickde = true
            }else{
                addType = "0"
                checkbox.setImage(Uncheckedimage, for: UIControlState.normal)
                isBoxclickde = false
            }
        
             conectUrl = WEBSERVICE_URL+"updateAddress.php"
        }
       print(addType)
        
    }
    
    @IBAction func btnUpdateButton(_ sender: Any) {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        let mobileNo = txtMobileFiled.text
        let houseNo = txtHouseNo.text
        let street = txtStreet.text
        let landmark = txtLandmark.text
        let city = txtCity.text
        let state = txtState.text
        let adressid = AddressId
        let pincode = txtPincode.text
        let country = txtCountry.text
        if addType == "1"
        {
            print("Checked")
        }
        else
        {
            addType = "0"
            print("Unchecked")
        }
        validateAddress(userId: userId,mobileNo: mobileNo!,houseNo: houseNo!,street: street!,landmark: landmark!,city: city!,state: state!,addressId: adressid,pincode: pincode!,country: country!,add_type: addType,defaultType: addType)
    }
    
    
    
    
    func validateAddress(userId: String,mobileNo: String,houseNo:String,street: String,landmark: String,city: String,state: String,addressId: String,pincode: String,country: String,add_type: String,defaultType:String) {
        
        let userId = userId
        let mobileNo = mobileNo
        let houseNo = houseNo
        let street = street
        let landmark = landmark
        let city = city
        let state = state
        let addressId = addressId
        let pincode = pincode
        
        let country = country
        let add_type = add_type
        let defaultType = defaultType
        var paramString = ""
        SVProgressHUD.show(withStatus: "Loading")
        let urlToRequest = conectUrl
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        if addressId.isEmpty{
            
             paramString = "userId="+userId+"&"+"mobileNo="+mobileNo+"&"+"houseNo="+houseNo+"&"+"street="+street+"&"+"landmark="+landmark+"&"+"city="+city+"&"+"state="+state+"&"+"pincode="+pincode+"&"+"country="+country+"&"+"add_type="+add_type+"&"+"defaultType="+defaultType
            
        }else{
            paramString = "userId="+userId+"&"+"mobileNo="+mobileNo+"&"+"houseNo="+houseNo+"&"+"street="+street+"&"+"landmark="+landmark+"&"+"city="+city+"&"+"state="+state+"&"+"addressId="+addressId+"&"+"pincode="+pincode+"&"+"country="+country+"&"+"add_type="+add_type+"&"+"defaultType="+defaultType
            
        }
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                SVProgressHUD.dismiss()
                return
            }
            if let data = data {
                DispatchQueue.main.async { // Correct
                    
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("***** \(String(describing: dataString))") //JSONSerialization
                    SVProgressHUD.dismiss()

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
                            self.backPressButton(self)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    }
                }else{
                    
                    let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            } catch let error as NSError {
                print(error)
                SVProgressHUD.dismiss()

            }
            
        }
        
        task.resume()
    }

    
    

}
