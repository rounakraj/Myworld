//
//  FriendsRequestViewController.swift
//  MyWorld
//
//  Created by MyWorld on 05/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import SwiftQRScanner
import SVProgressHUD

class FriendsRequestViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,QRScannerCodeDelegate{
    
    @IBOutlet weak var tableviewFriendRequest: UITableView!
    private var User = [PublicUser]()
    var EmailID = String()
    let scanner = QRCodeScannerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewFriendRequest.dataSource = self
        tableviewFriendRequest.delegate = self
        validateFriendList(UserId: UserDefaults.standard.value(forKey: "userId") as! String)
    }

    
    @IBAction func backPress(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }
    
    @IBAction func AddFriends(_ sender: Any) {
        AddFriends()
    }
    
    func validateFriendList(UserId:String) {
        let userId=UserId
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"getpublicUsers.php"
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
                    //self.activityindicator.stopAnimating();
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponsePublicUser \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadUser = try decoder.decode(PublicUsers.self, from: data!)
                    self.User = downloadUser.User
                    DispatchQueue.main.async { // Correct
                        
                        self.tableviewFriendRequest.reloadData()
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
    
    func AddFriends(){
        
        
        let actionSheet = UIAlertController(title: "Friends Source", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Search By Name", style: .default, handler: {(action: UIAlertAction)in
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SearchFriendsViewController") as! SearchFriendsViewController
            desCV.searchKey = "searchName"
            self.navigationController?.pushViewController(desCV, animated: true)
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Search By Email", style: .default, handler: {(action: UIAlertAction)in
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SearchFriendsViewController") as! SearchFriendsViewController
            desCV.searchKey = "searchEmail"
            self.navigationController?.pushViewController(desCV, animated: true)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Search in the List", style: .default, handler: {(action: UIAlertAction)in
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendsRequestViewController") as! FriendsRequestViewController
            self.navigationController?.pushViewController(desCV, animated: true)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Scan QR Code", style: .default, handler: {(action: UIAlertAction)in
            self.scanner.delegate = self
            self.present(self.scanner, animated: true, completion: nil)
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    func qrCodeScanningDidCompleteWithResult(result: String) {
        print("result:\(result)")
        sendFriendRequest(email: result)
        scanner.dismisAction()
    }
    
    func qrCodeScanningFailedWithError(error: String) {
        print("error:\(error)")
        scanner.dismisAction()
        
    }
    
    func sendFriendRequest(email:String) -> Void {
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        
        let postData = NSMutableData(data: "userId=\(UserId)".data(using: String.Encoding.utf8)!)
        postData.append("&emailId=\(email)".data(using: String.Encoding.utf8)!)
        SVProgressHUD.show(withStatus: "Loading")
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "sendfriendRequest.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                SVProgressHUD.dismiss()
            }else{
                
                print(data);
                SVProgressHUD.dismiss()
                if data .value(forKey: "responseCode") as! String == "200"{
                    SVProgressHUD.showSuccess(withStatus: "responseMessage")
                }else{
                    SVProgressHUD.showInfo(withStatus: "responseMessage")
                    
                }
                
            }
            
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsRequestTableViewCell")as? FriendsRequestTableViewCell else{ return UITableViewCell ()}
        
        cell.lblFRName.text = User[indexPath.row].firstName
        cell.lblFREmailId.text = User[indexPath.row].emailId
        cell.imageFR.layer.cornerRadius = cell.imageFR.frame.size.width / 2;
        cell.imageFR.clipsToBounds = true;
        
        cell.btnFRButton.layer.borderWidth = 0.8
        cell.btnFRButton.layer.borderColor = UIColor.gray.cgColor
        
        cell.btnFRButton.addTarget(self, action: #selector(validatesendfriendRequest), for: UIControlEvents.touchUpInside)
        cell.btnFRButton.tag = indexPath.row
        
        if User[indexPath.row].profileImage.hasPrefix("graph"){
            if let imageURL = URL(string: "https://"+User[indexPath.row].profileImage){
                cell.imageFR.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
            }
        }
        else if (User[indexPath.row].profileImage.hasSuffix(".jpg") || User[indexPath.row].profileImage.hasSuffix(".jpeg")){
            if let imageURL = URL(string: User[indexPath.row].profileImage){
                cell.imageFR.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
            }
        }
        else{
            /*if let imageURL = URL(string: "http://18.221.196.77/myworldapi/upload/defaultuserprofile.png"){
                cell.imageFR.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "ic_profile"))
            }*/
            cell.imageFR.sd_setImage(with: URL(string: User[indexPath.row].profileImage), placeholderImage: UIImage(named: "ic_profile"))
        }
        return cell
    }
    
    @objc func validatesendfriendRequest(sender: UIButton) {
        //self.activityindicator.startAnimating();
        let buttonTag = sender.tag
        print(buttonTag)
        EmailID = User[buttonTag].emailId
        print(EmailID)
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        let urlToRequest = WEBSERVICE_URL+"sendfriendRequest.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        print(UserId)
        let paramString="userId="+UserId+"&"+"emailId="+EmailID
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
    
    
    
    
}
