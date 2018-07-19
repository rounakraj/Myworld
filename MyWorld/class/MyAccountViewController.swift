//
//  MyAccountViewController.swift
//  MyWorld
//
//  Created by MyWorld on 05/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import  Alamofire
import SVProgressHUD

class MyAccountViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    @IBOutlet weak var txtFiledFirstName: UITextField!
    @IBOutlet weak var txtFiledLastName: UITextField!
    @IBOutlet weak var txtFiledUserName: UITextField!
    @IBOutlet weak var txtFiledEmailId: UITextField!
    @IBOutlet weak var txtFildMobileNumber: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var imgProfileIcon: UIImageView!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIButton!

    var counter = 0
    var imageData1 = NSData()
    var imageData2 = NSData()
    var isEdit = false
    
    
    @IBAction func btnEditProfile(_ sender: Any) {
        if isEdit {
            setIntraction(isEdit: false)
            let firstName = txtFiledFirstName.text
            let lastName = txtFiledLastName.text
            let mobileNo = txtFildMobileNumber.text
            SendDataToServer(firstName: firstName!,lastName: lastName!,mobileNo: mobileNo!,userStatus: "")
            isEdit = false
            editButton.setTitle("Edit", for: .normal)
           
        }else{
             isEdit = true
            setIntraction(isEdit: true)
            editButton.setTitle("Save", for: .normal)

        }
    }
    func setIntraction(isEdit:Bool) -> Void {
        txtFiledFirstName.isUserInteractionEnabled = isEdit
        txtFiledEmailId.isUserInteractionEnabled = isEdit
        txtFildMobileNumber.isUserInteractionEnabled = isEdit
        txtFiledUserName.isUserInteractionEnabled = isEdit
        txtFiledLastName.isUserInteractionEnabled = isEdit
    }
    @IBAction func camer1(_ sender: Any) {
        if isEdit {
        cameraClick()
        counter = 1
        }
    }
    

    @IBAction func camera2(_ sender: Any) {
        if isEdit {
        cameraClick()
        counter = 2
        }
    }
    
    @IBAction func backPress(_ sender: Any) {
        
        navigationController?.popViewController(animated:true)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BootomBar.shared.showBootomBar()
        
        setIntraction(isEdit: false)
        
        imgProfileIcon.layer.cornerRadius = imgProfileIcon.frame.size.width / 2;
        imgProfileIcon.clipsToBounds = true;
        getuserProfile(UserId: UserDefaults.standard.value(forKey: "userId") as! String)      

    }
   
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        BootomBar.shared.showBootomBar()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        BootomBar.shared.hideBootomBar()
        
    }
    
    func getuserProfile(UserId:String) {
        let userId=UserId
        SVProgressHUD.show()
        let urlToRequest = WEBSERVICE_URL+"getuserProfile.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+userId
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
                    SVProgressHUD.dismiss()
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                
                DispatchQueue.main.async { // Correct
                    
                    let  firstName = Data["firstName"] as? String
                    let  lastName = Data["lastName"] as? String
                    let  userName = Data["userName"] as? String
                    let  emailId = Data["emailId"] as? String
                    let  mobileNo = Data["mobileNo"] as? String
                    let  profileImage = Data["profileImage"] as? String
                    let  coverImagepic = Data["coverImage"] as? String
    
                    self.txtFiledFirstName.text = firstName
                    self.txtFiledLastName.text = lastName
                    self.txtFiledUserName.text = userName
                    self.txtFiledEmailId.text = emailId
                    self.txtFildMobileNumber.text = mobileNo
                    let catPictureURL = URL(string: profileImage!)
                    let session = URLSession(configuration: .default)
                    let downloadPicTask = session.dataTask(with: catPictureURL!) { (data, response, error) in
                        if let e = error {
                            print("Error downloading cat picture: \(e)")
                        } else {
                            if let res = response as? HTTPURLResponse {
                                print("Downloaded cat picture with response code \(res.statusCode)")
                                if let imageData = data {
                                    let image = UIImage(data: imageData)
                                DispatchQueue.main.async { // Correct
                                    self.imgProfileIcon.image = image
                                 }
                                } else {
                                    print("Couldn't get image: Image is nil")
                                }
                            } else {
                                print("Couldn't get response code for some reason")
                            }
                        }
                    }
                    
                    downloadPicTask.resume()
                    if (coverImagepic?.isEmpty)!{
                        
                    }else{
                    let catPictureURL1 = URL(string: coverImagepic!)
                    let session1 = URLSession(configuration: .default)
                    let downloadPicTask1 = session1.dataTask(with: catPictureURL1!) { (data, response, error) in
                        if let e = error {
                            print("Error downloading cat picture: \(e)")
                        } else {
                            if let res = response as? HTTPURLResponse {
                                print("Downloaded cat picture with response code \(res.statusCode)")
                                if let imageData = data {
                                    let image = UIImage(data: imageData)
                                    
                                    DispatchQueue.main.async { // Correct
                                        
                                       self.coverImage.image = image
                                    }
                                    
                                   
                                } else {
                                    print("Couldn't get image: Image is nil")
                                }
                            } else {
                                print("Couldn't get response code for some reason")
                            }
                        }
                    }
                    
                    downloadPicTask1.resume()
                }
                
                }
                
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }
    
    
    
    func cameraClick()
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction)in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                
                // Create the alert controller
                let alertController = UIAlertController(title: "My World", message: "Camera not suport", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction)in
            
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        counter = 0
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
@objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let  chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("imagePickerController")
        if counter == 1{
            coverImage.image = chosenImage
            imageData2 = chosenImage.lowestQualityJPEGNSData

            print("caunter call 1")
        }else if counter == 2{
            
            imgProfileIcon.image = chosenImage
            imageData1 = chosenImage.lowestQualityJPEGNSData

            print("caunter call 2")
            
            
        }
        picker.dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:true, completion: nil)
    }

    
    func SendDataToServer(firstName: String,lastName:String,mobileNo:String,userStatus:String) -> Void {
        let param = [
            "userId" : UserDefaults.standard.string(forKey: "userId"),
            "firstName": firstName,
            "lastName": lastName,
            "mobileNo": mobileNo,
            "userStatus":userStatus]
        SVProgressHUD.show(withStatus: "Loading")
     
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if self.imageData1.length>0{
            multipartFormData.append(self.imageData1 as Data, withName: "image1", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            if self.imageData2.length>0{
            multipartFormData.append(self.imageData2 as Data, withName: "image2", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in param {
                
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key )
                
            }
            
        }, to: WEBSERVICE_URL + "updateuserProfile.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("progress \(progress) " )
                    
                })
                
                upload.responseJSON { response in
                    //print response.result
                    print("response data \(response) " )
                    let jsonResponse = response.result.value as! NSDictionary
                    if jsonResponse.value(forKey: "responseCode") as! String == "200"{
                        DispatchQueue.main.async(execute: {
                            SVProgressHUD.dismiss()
                            let alertController = UIAlertController(title: "Image", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                            SVProgressHUD.dismiss()
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                // Do whatever you want with inputTextField?.text
                                
                            })
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                            self.navigationController?.popViewController(animated:true)
                        })
                    }else{
                        DispatchQueue.main.async(execute: {
                            let alertController = UIAlertController(title: "Myworld", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                            SVProgressHUD.dismiss()
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                // Do whatever you want with inputTextField?.text
                                
                            })
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                        })
                    }
                    
                    
                    
                }
                
            case .failure( _):
                SVProgressHUD.dismiss()
                break
                //print encodingError.description
                
            }
        }
        
        
    }
}
