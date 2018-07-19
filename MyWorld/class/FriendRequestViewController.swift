//
//  FriendRequestViewController.swift
//  MyWorld
//
//  Created by MyWorld on 11/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftQRScanner

class FriendRequestViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,QRScannerCodeDelegate{

    @IBOutlet weak var tableView: UITableView!
    private var friendRequest = [FriendRequest]()
    let scanner = QRCodeScannerController()
    var userId = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        validateShowfriendRequest()
    }
    
    @IBAction func backPress(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }
    
    
    @IBAction func AddFriends(_ sender: Any) {
        AddFriends()
    }

    func validateShowfriendRequest() {
        //let userId = UserDefaults.standard.value(forKey: "userId") as! String
        SVProgressHUD.show(withStatus: "Loading")
        let urlToRequest = WEBSERVICE_URL+"showfriendRequest.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+self.userId
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
                    let decoder = JSONDecoder()
                    let  downloadfriendRequest = try decoder.decode(FriendRequests.self, from: data!)
                    self.friendRequest = downloadfriendRequest.friendRequest
                    DispatchQueue.main.async { // Correct
                       self.tableView.reloadData()
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
        return friendRequest.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendReqestTableViewCell")as? FriendReqestTableViewCell else{ return UITableViewCell ()}
        cell.lblRequestName.text = friendRequest[indexPath.row].firstName
        cell.imgRequest.layer.cornerRadius = cell.imgRequest.frame.size.width / 2;
        cell.imgRequest.clipsToBounds = true;
        cell.btnAccept.layer.borderWidth = 0.8
        cell.btnAccept.layer.borderColor = UIColor.gray.cgColor
        cell.btnReject.layer.borderWidth = 0.8
        cell.btnReject.layer.borderColor = UIColor.gray.cgColor
        cell.btnAccept.addTarget(self, action: #selector(callAcceptfriendRequest), for: UIControlEvents.touchUpInside)
        cell.btnReject.addTarget(self, action: #selector(callRejectfriendRequest), for: UIControlEvents.touchUpInside)
       
        if self.userId == UserDefaults.standard.value(forKey: "userId") as! String{
             cell.btnAccept.isHidden = false
            cell.btnReject.isHidden = false

        }else{
            cell.btnAccept.isHidden = true
            cell.btnReject.isHidden = true
        }
        
        if (friendRequest[indexPath.row].profileImage.hasPrefix("graph")){
            if let imageURL = URL(string: "https://"+friendRequest[indexPath.row].profileImage){
                cell.imgRequest.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "ic_profile"))
            }
        }else{
            cell.imgRequest.sd_setImage(with: URL(string: friendRequest[indexPath.row].profileImage), placeholderImage: UIImage(named: "ic_profile"))
        }
        return cell
    }
    
    
    @objc func callRejectfriendRequest(sender: UIButton) -> Void {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        validateRejectfriendRequest(UserId1:friendRequest[(indexPath?.row)!].userId)
    }
    
    func validateRejectfriendRequest(UserId1:String) {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        SVProgressHUD.show(withStatus: "Loading")
        let urlToRequest = WEBSERVICE_URL+"rejectfriendRequest.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId2="+userId+"&"+"userId1="+UserId1
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
                    self.navigationController?.popViewController(animated: true)
                    /*DispatchQueue.main.async { // Correct
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }*/
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
    
    @objc func callAcceptfriendRequest(sender: UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        validateAcceptfriendRequest(UserId1:friendRequest[(indexPath?.row)!].userId)
    }
    
    func validateAcceptfriendRequest(UserId1:String) {
        SVProgressHUD.show(withStatus: "Loading")
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        let urlToRequest = WEBSERVICE_URL+"acceptfriendRequest.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId2="+userId+"&"+"userId1="+UserId1
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
                    self.navigationController?.popViewController(animated: true)
                    /*DispatchQueue.main.async { // Correct
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil
                    })*/
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
