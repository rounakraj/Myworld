//
//  FriendsListViewController.swift
//  MyWorld
//
//  Created by MyWorld on 11/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftQRScanner

class FriendsListViewController: UIViewController,UITableViewDataSource,QRScannerCodeDelegate {

    let scanner = QRCodeScannerController()
    var userId = String()
    private var friendlist = [FriendsResourse]()
    
    @IBAction func AddFriends(_ sender: Any) {
        
        AddFriends()
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        navigationController?.popViewController(animated:true)
    }
    
    @IBOutlet weak var tableviewcell: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validateFriendList(UserId: self.userId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

    func validateFriendList(UserId:String) {
        let userId=UserId
        SVProgressHUD.show(withStatus: "Loading")
        let urlToRequest = WEBSERVICE_URL+"getFriends.php"
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
                SVProgressHUD.dismiss()
                return
            }
            if let data = data {
                DispatchQueue.main.async { // Correct
                    
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("***** \(String(describing: dataString))") //JSONSerialization
                    
                }
            }
            SVProgressHUD.dismiss()
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadFriendList = try decoder.decode(Friends.self, from: data!)
                    self.friendlist = downloadFriendList.friendList
                    DispatchQueue.main.async { // Correct
                      
                        self.tableviewcell.reloadData()
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendlist.count
    }
   /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100;
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListTableViewCell")as? FriendListTableViewCell else{ return UITableViewCell ()}
        
        cell.lblFriendsName.text = friendlist[indexPath.row].firstName
        cell.lblFriendsEmailId.text = friendlist[indexPath.row].emailId
        cell.imageFriendsImageView.layer.cornerRadius = cell.imageFriendsImageView.frame.size.width / 2;
        cell.imageFriendsImageView.clipsToBounds = true;
    
        cell.btnFollow.layer.borderWidth = 0.8
        cell.btnFollow.layer.borderColor = UIColor.gray.cgColor
        cell.btnFollow.addTarget(self, action: #selector(handleFollowAction), for: UIControlEvents.touchUpInside)
        cell.btnFollow.tag = indexPath.row
        
        cell.btnUnfriend.layer.borderWidth = 0.8
        cell.btnUnfriend.layer.borderColor = UIColor.gray.cgColor
        cell.btnUnfriend.addTarget(self, action: #selector(handleUnfriendAction), for: UIControlEvents.touchUpInside)
        cell.btnUnfriend.tag = indexPath.row
        
        if self.userId == UserDefaults.standard.value(forKey: "userId") as! String{
            cell.btnUnfriend.isHidden = false
            cell.btnFollow.isHidden = false
            
        }else{
            cell.btnUnfriend.isHidden = true
            cell.btnFollow.isHidden = true
        }
        
        if (friendlist[indexPath.row].followingStatus == "1" ){
            print("FollowingStatus")
            print(friendlist[indexPath.row].followingStatus)
            cell.btnFollow.setTitle("Un-Follow", for: .normal)
        }
        else{
            print("FollowingStatus")
            print(friendlist[indexPath.row].followingStatus)
            cell.btnFollow.setTitle("Follow", for: .normal)
        }
        if (friendlist[indexPath.row].profileImage.hasPrefix("graph")){
            if let imageURL = URL(string: "https://"+friendlist[indexPath.row].profileImage){
                cell.imageFriendsImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "ic_profile"))
            }
        }else{
            cell.imageFriendsImageView.sd_setImage(with: URL(string: friendlist[indexPath.row].profileImage), placeholderImage: UIImage(named: "ic_profile"))
        }
        return cell
    }
    
    @objc func handleFollowAction(sender: UIButton) {
        print("handleFollowAction")
        let buttonTag = sender.tag
        print(buttonTag)
        let UserID2 = friendlist[buttonTag].userId
        print(UserID2)
        let Following = friendlist[buttonTag].followingStatus
        print(Following)
        
        let UserId1 = UserDefaults.standard.value(forKey: "userId") as! String
        print(UserId1)
        
        if (Following == "1" )
        {
             print("FollowingStatus 1")
            //Handle Unfollow
                let urlToRequest = WEBSERVICE_URL+"unfollowUser.php"
                let url4 = URL(string: urlToRequest)!
                let session4 = URLSession.shared
                let request = NSMutableURLRequest(url: url4)
                request.httpMethod = "POST"
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                let paramString="userId1="+UserId1+"&"+"userId2="+UserID2
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
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                    // Do whatever you want with inputTextField?.text
                                    self.viewWillAppear(true)
                                })
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
        else
        {
            print("FollowingStatus 0")
            //Handle Follow
            let urlToRequest = WEBSERVICE_URL+"followUser.php"
            let url4 = URL(string: urlToRequest)!
            let session4 = URLSession.shared
            let request = NSMutableURLRequest(url: url4)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let paramString="userId1="+UserId1+"&"+"userId2="+UserID2
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
                            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                // Do whatever you want with inputTextField?.text
                                self.viewWillAppear(true)
                            })
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
    
    
    @objc func handleUnfriendAction(sender: UIButton) {
        print("handleUnfriendAction")
        print("Unfriend The Person")
        let buttonTag = sender.tag
        print(buttonTag)
        let UserId1 = UserDefaults.standard.value(forKey: "userId") as! String
        print(UserId1)
        let UserID2 = friendlist[buttonTag].userId
        print(UserID2)
        
        //Handle Follow
        let urlToRequest = WEBSERVICE_URL+"userUnfriend.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId1="+UserId1+"&"+"userId2="+UserID2
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
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            // Do whatever you want with inputTextField?.text
                            self.viewWillAppear(true)
                        })
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

}
