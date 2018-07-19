//
//  ProfileViewController.swift
//  MyWorld
//
//  Created by MyWorld on 07/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class ProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var profileType = ""
    var userId = String()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFollowerscount: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lblFollowingcount: UILabel!
    @IBOutlet weak var lblFriendscount: UILabel!
    @IBOutlet weak var lblRequestCount: UILabel!
    var isKeyboardDismiss:Bool = false
    
    @IBAction func btnFollowers(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FollowerViewController") as! FollowerViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func btnFollowing(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FollowingViewController") as! FollowingViewController
        desCV.userId = self.userId
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func btnFriends(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController") as! FriendsListViewController
         desCV.userId = self.userId
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    
    @IBAction func btnRequest(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendRequestViewController") as! FriendRequestViewController
        desCV.userId = self.userId
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    
    @objc func btnCheckSwitch(_ sender: Any) {
        if (sender as AnyObject).isOn == true{
            profileType = "Private"
            accountSetPrivate()
        }else{
            profileType = "Public"
            accountSetPublic()
        }
    }
    
     @objc func btnBlockSwitch(_ sender: Any) {
        let dic = ["login_user_id" : UserDefaults.standard.string(forKey: "userId")!,
                   "block_user_id" : UserDefaults.standard.string(forKey: "userId")!]  as [String : Any]
        
        self.sendDataToServerUsingWrongContent(param:dic)
    }
    
    @objc func btnReportTapped() {
       self.sendMessage()
    }
    
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func backPress(_ sender: Any) {
        navigationController?.popViewController(animated:true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view1.layer.borderWidth = 0.8
        view1.layer.borderColor = UIColor.gray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2;
        profileImage.clipsToBounds = true;
        getUpdatesDetailData()
        getuserProfile()
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.userId == UserDefaults.standard.value(forKey: "userId") as! String ? 6:8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:MyAccountTVC?
        
        if self.userId == UserDefaults.standard.value(forKey: "userId") as! String{
            if indexPath.section == 0 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! MyAccountTVC)
                
            }else if indexPath.section == 1 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MyAccountTVC)
                
            }else if indexPath.section == 2 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MyAccountTVC)
                cell?.switchBtn.addTarget(self, action: #selector(btnCheckSwitch(_:)), for: .valueChanged)
                if self.userId == UserDefaults.standard.value(forKey: "userId") as! String{
                    cell?.switchBtn.isEnabled = true
                    
                }else{
                    cell?.switchBtn.isEnabled = false
                }
            }
            else if indexPath.section == 3 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! MyAccountTVC)
            }
            else if indexPath.section == 4 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! MyAccountTVC)
            }
            else if indexPath.section == 5 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! MyAccountTVC)
            }
        }
        else{
            if indexPath.section == 0 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! MyAccountTVC)
                
            }else if indexPath.section == 1 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MyAccountTVC)
                
            }else if indexPath.section == 2 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MyAccountTVC)
                cell?.switchBtn.addTarget(self, action: #selector(btnCheckSwitch(_:)), for: .valueChanged)
                if self.userId == UserDefaults.standard.value(forKey: "userId") as! String{
                    cell?.switchBtn.isEnabled = true
                    
                }else{
                    cell?.switchBtn.isEnabled = false
                }
            }
            else if indexPath.section == 3 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! MyAccountTVC)
                cell?.blockSwitchBtn.addTarget(self, action: #selector(btnBlockSwitch(_:)), for: .valueChanged)
            }
            else if indexPath.section == 4 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! MyAccountTVC)
                cell?.reportSwitchBtn.isHidden = true
                //cell?.reportSwitchBtn.addTarget(self, action: #selector(btnReportSwitch(_:)), for: .valueChanged)
                
            }
            else if indexPath.section == 5 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! MyAccountTVC)
                
            }
            else if indexPath.section == 6 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! MyAccountTVC)
            }
            else if indexPath.section == 7 {
                cell = (tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! MyAccountTVC)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
         if self.userId == UserDefaults.standard.value(forKey: "userId") as! String{
            if indexPath.section == 0{
                if self.userId == UserDefaults.standard.value(forKey: "userId") as! String{
                    let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let desCV = MainStoryboard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as! OrderHistoryViewController
                    self.navigationController?.pushViewController(desCV, animated: true)
                }else{
                    showToast(message: "Sorry can't see order history")
                }
            }
            if indexPath.section == 1{
                let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController") as! FriendsListViewController
                self.navigationController?.pushViewController(desCV, animated: true)
            }
            if indexPath.section == 3{
                print("Address Book")
                if self.userId == UserDefaults.standard.value(forKey: "userId") as! String{
                    let mainStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
                    let desController=mainStoryboard.instantiateViewController(withIdentifier: "AdressViewController")as!AdressViewController
                    self.navigationController?.pushViewController(desController, animated: true)
                }
                else{
                    showToast(message: "Sorry can't see address")
                }
            }
            if indexPath.section == 4{
                print("Contact Us")
                let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ContactusViewController") as! ContactusViewController
                self.navigationController?.pushViewController(desCV, animated: true)
            }
            if indexPath.section == 5{
                print("Logout")
                UserDefaults.standard.removeObject(forKey: "userId")
                let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let desCV = MainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(desCV, animated: true)
            }
        }
         else{
            if indexPath.section == 0{
                if self.userId == UserDefaults.standard.value(forKey: "userId") as! String{
                    let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let desCV = MainStoryboard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as! OrderHistoryViewController
                    self.navigationController?.pushViewController(desCV, animated: true)
                }else{
                    showToast(message: "Sorry can't see order history")
                }
            }
            if indexPath.section == 1{
                let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController") as! FriendsListViewController
                self.navigationController?.pushViewController(desCV, animated: true)
            }
            if indexPath.section == 4{
               self.btnReportTapped()
            }
            if indexPath.section == 5{
                print("Address Book")
                if self.userId == UserDefaults.standard.value(forKey: "userId") as! String{
                    let mainStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
                    let desController=mainStoryboard.instantiateViewController(withIdentifier: "AdressViewController")as!AdressViewController
                    self.navigationController?.pushViewController(desController, animated: true)
                }
                else{
                    showToast(message: "Sorry can't see address")
                }
            }
            if indexPath.section == 6{
                print("Contact Us")
                let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ContactusViewController") as! ContactusViewController
                self.navigationController?.pushViewController(desCV, animated: true)
            }
            if indexPath.section == 7{
                print("Logout")
                UserDefaults.standard.removeObject(forKey: "userId")
                let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let desCV = MainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(desCV, animated: true)
            }
        }
    }
    
    func getUpdatesDetailData() -> Void {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        let postData = NSMutableData(data: "userId=\(self.userId)".data(using: String.Encoding.utf8)!)
        
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "getprofileInfo.php", uiView: self.view, withCompletionHandler: {data,error in
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
                
                if data .value(forKey: "responseCode") as! String == "200"{
                    DispatchQueue.main.async(execute: {
                        
                        let value: AnyObject? = data.value(forKey: "statusList") as AnyObject
                        
                        if value is NSString {
                            print("It's a string")
                            
                        } else if value is NSArray {
                            print("It's an NSArray")
                            //self.shareUpdateArray = value as! NSArray
                            
                        }
                        self.lblFollowerscount.text = data.value(forKey: "followers") as? String
                        self.lblFollowingcount.text = data.value(forKey: "following") as? String
                        self.lblFriendscount.text = data.value(forKey: "friends") as? String
                        self.lblRequestCount.text = data.value(forKey: "friendsreq") as? String
                        let indexPath = IndexPath(row: 0, section: 2)
                        let cell = self.tableView.cellForRow(at: indexPath) as! MyAccountTVC
                        if data .value(forKey: "profileType") as! String == "Public"{
                            
                            cell.switchBtn.isOn = false
                        }else{
                            cell.switchBtn.isOn = true
                        }
                        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.isKeyboardDismiss = true
        self.view.endEditing(true)
        return true
    }
    
    
    func sendMessage(){
        let alertController = UIAlertController(title: "MyWorld", message: "Send Message", preferredStyle: .alert)
        let send = UIAlertAction(title: "Send", style: UIAlertActionStyle.default) { UIAlertAction in
            let textField = alertController.textFields![0]
            print(textField.text!)
            if !self.isKeyboardDismiss && textField.text!.count > 0{
                let dic = ["login_user_id" : UserDefaults.standard.string(forKey: "userId")!,
                           "block_user_id" : UserDefaults.standard.string(forKey: "userId")!,
                           "report" : "1",
                           "report_text" : textField.text!]  as [String : Any]
                self.sendDataToServerUsingWrongContent(param:dic)
            }
            else{
                self.isKeyboardDismiss = false
            }
        }
        alertController.addAction(send)
        
        alertController .addTextField { (textField) in
            textField.placeholder = "message"
            textField.keyboardType = .default
            textField.delegate = self
        }
        self.present(alertController, animated: true, completion:{
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MyPosts.alertClose(gesture:))))
        })
    }
    
    
    func getuserProfile() -> Void {
        //let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        let postData = NSMutableData(data: "userId=\(self.userId)".data(using: String.Encoding.utf8)!)
        //let postData = NSMutableData(data: "userId=\(String(describing: UserDefaults.standard.string(forKey: "userId")!))".data(using: String.Encoding.utf8)!)
        
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "getuserProfile.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "MyWorld", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        // Do whatever you want with inputTextField?.text
                        
                    })
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                })
                
            }else{
                
                print(data);
                
                DispatchQueue.main.async(execute: {
                    
                    let value: AnyObject? = data.value(forKey: "statusList") as AnyObject
                    
                    if value is NSString {
                        print("It's a string")
                        
                    } else if value is NSArray {
                        print("It's an NSArray")
                        
                    }
                
                    let firstName = data.value(forKey: "firstName") as? String
                    let lastName = data.value(forKey: "lastName") as? String
                    let first = firstName!+" "+lastName!
                    self.lblUserName.text = first
                    let profile = data.value(forKey: "profileImage") as? String
                    let coverImage = data.value(forKey: "coverImage") as? String
                    
                    if let imageURL = URL(string: coverImage!){
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: imageURL)
                            
                            if let data = data{
                                let image = UIImage(data: data)
                                DispatchQueue.main.async {
                                    self.coverImage.image = image
                                }
                            }
                        }
                    }
                    if (profile?.hasPrefix("graph"))!{
                        if let imageURL = URL(string: "https://"+profile!){
                            self.profileImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "ic_profile"))
                        }
                    }else{
                        self.profileImage.sd_setImage(with: URL(string: profile!), placeholderImage: UIImage(named: "ic_profile"))
                    }
                    
                    
                })
                
                
            }
            
        })
    }
    
    
    
    @objc func accountSetPrivate() {
        
        let alertView = UIAlertController(title: "Change to Private Account", message: "When your account is private, only people you appove can see your phots videos and stories on Myworld. Your existing followers won't be affected.", preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            
            self.validateUpdateprofileType()
        })
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            
        })
        alertView.addAction(library)
        alertView.addAction(Cancel)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    @objc func accountSetPublic() {
        
        let alertView = UIAlertController(title: "Change to Public Account?", message: "Anyone will be able to see your photos, videos and stories. You will no longer need to approve followers.", preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            self.validateUpdateprofileType()
        })
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            
        })
        alertView.addAction(library)
        alertView.addAction(Cancel)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    func validateUpdateprofileType() {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"updateprofileType.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+userId+"&"+"profileType"+profileType
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
                    
                    
                    DispatchQueue.main.async { // Correct
                        
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
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
                
            }
            
        }
        
        task.resume()
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func sendDataToServerUsingWrongContent(param:[String:Any]){
        
        SVProgressHUD.show(withStatus: "Loading")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key )
                
            }
            
        }, to: WEBSERVICE_URL + "blockAndReport.php")
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
                        let alertController = UIAlertController(title: "Image", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                        SVProgressHUD.dismiss()
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            // Do whatever you want with inputTextField?.text
                            self.viewWillAppear(true)
                        })
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else{
                        DispatchQueue.main.async(execute: {
                            let alertController = UIAlertController(title: "Image", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                            SVProgressHUD.dismiss()
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                // Do whatever you want with inputTextField?.text
                                self.navigationController?.popViewController(animated:true)
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

