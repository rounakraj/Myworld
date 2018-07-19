//
//  SelectFriendsViewController.swift
//  MyWorld
//
//  Created by MyWorld on 11/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class SelectFriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableviewSelectfriends: UITableView!
    
    @IBOutlet weak var btnBackground: UIView!
    private var friendList = [ChatFriendList]()
     var StringBuilder = String()
    var allUserId = String()
    @IBAction func btnBackPress(_ sender: Any) {
        
        navigationController?.popViewController(animated:true)
        BottomViewController.sharedURLSessio.isHidden = false
    }
   @objc var imageData = NSData()
   @objc var videoesData = NSData()
   @objc var thumb_nail = NSData()
   @objc var message = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        BottomViewController.sharedURLSessio.isHidden = true
        btnBackground.isHidden = true
        validateFriendList(UserId: UserDefaults.standard.value(forKey: "userId") as! String)
    }

    @IBAction func btnActionButton(_ sender: Any) {
        
        for word in friendList {
            print(">>>>>>>>",word.userId)
            
            StringBuilder.append(word.userId);
            StringBuilder.append(",");
        }
        
       allUserId = StringBuilder.substring(to: StringBuilder.endIndex)
        
        SendDataToServerUpdateGlobalStatus()
        print(">>>>>>>>",allUserId)
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as? SelectFriendsTVCell else{ return UITableViewCell ()}
        
        cell.lblSelectFrName?.text = friendList[indexPath.row].firstName+" "+friendList[indexPath.row].lastName
       
        cell.imgSelectFrimaigeview?.layer.cornerRadius = (cell.imgSelectFrimaigeview?.frame.size.width)! / 2;
        cell.imgSelectFrimaigeview?.clipsToBounds = true;
    
        if (friendList[indexPath.row].profileImage.hasPrefix("graph")){
            if let imageURL = URL(string: "https://"+friendList[indexPath.row].profileImage){
                cell.imgSelectFrimaigeview.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "ic_profile"))
            }
        }else{
            cell.imgSelectFrimaigeview.sd_setImage(with: URL(string: friendList[indexPath.row].profileImage), placeholderImage: UIImage(named: "ic_profile"))
        }
        

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark
        {
         
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
              btnBackground.isHidden = false
        }
    }

    func validateFriendList(UserId:String) {
        let userId=UserId
        //self.activityindicator.startAnimating();
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
                    let  downloadfriendList = try decoder.decode(ChatFriendLists.self, from: data!)
                    self.friendList = downloadfriendList.friendList
                    DispatchQueue.main.async { // Correct
                        
                        self.tableviewSelectfriends.reloadData()
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
    
    func SendDataToServerUpdateGlobalStatus() -> Void {
        
        let param = ["userId" : UserDefaults.standard.string(forKey: "userId"),
                     "alluserId":allUserId]
        
        SVProgressHUD.show(withStatus: "Loading")
        Alamofire.upload(multipartFormData: { (multipartFormData) in
          
                if self.imageData.length > 0{
                    multipartFormData.append(self.imageData as Data, withName: "chatFile", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
            if self.videoesData.length > 0{
                
                 multipartFormData.append(self.thumb_nail as Data, withName: "thumbVideo", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                
                multipartFormData.append(self.videoesData as Data, withName: "chatVideo", fileName: "\(Date().timeIntervalSince1970).mov", mimeType: "video/mov")
            }
            if self.message != nil{
                multipartFormData.append(((self.message as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: "chatMsg" )
                
            }
            for (key, value) in param {
                
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key )
                
            }
            
        }, to: WEBSERVICE_URL + "sendBulkImage.php")
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
                    SVProgressHUD.dismiss()

                    let jsonResponse = response.result.value as! NSDictionary
                    if jsonResponse.value(forKey: "responseCode") as! String == "200"{
                        DispatchQueue.main.async(execute: {
                            
                            
                            let alertController = UIAlertController(title: "Image", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                            
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                // Do whatever you want with inputTextField?.text
                                self.navigationController?.popViewController(animated:true)
                                BottomViewController.sharedURLSessio.isHidden = false
                            })
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                            
                        })
                    }else{
                        DispatchQueue.main.async(execute: {
                            let alertController = UIAlertController(title: "Myworld", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                            
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
