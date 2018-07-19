//
//  SearchFriendsViewController.swift
//  MyWorld
//
//  Created by MyWorld on 29/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchFriendsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    @IBOutlet weak var searchView: UISearchBar!
   @objc var searchKey = String()
    var EmailID = String()
   private var User = [SerchFriends]()
    
    @IBOutlet weak var tableviewcells: UITableView!
    
    @IBAction func btnBackPress(_ sender: Any) {
        
        navigationController?.popViewController(animated:true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchKeydata = searchBar.text
        validateFriendList(UserId: UserDefaults.standard.value(forKey: "userId") as! String,searchKeydata: searchKeydata!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewcells.dataSource = self
        tableviewcells.delegate = self
       
      
    }

    func validateFriendList(UserId:String,searchKeydata:String) {
        let userId = UserId
        let searchKeydata = searchKeydata
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"searchUsers.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+userId+"&"+searchKey+"="+searchKeydata
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
                    
                    let decoder = JSONDecoder()
                    let  downloadUser = try decoder.decode(SerchFriend.self, from: data!)
                    self.User = downloadUser.User
                    DispatchQueue.main.async { // Correct
                        
                        self.tableviewcells.reloadData()
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
    

    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return User.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFriendTableViewCell")as? SearchFriendTableViewCell else{ return UITableViewCell ()}
    
        cell.lblSerchEmail.text = User[indexPath.row].firstName
        cell.lblSerchEmailIds.text = User[indexPath.row].emailId
        cell.imfSearchFriendEmailIds.layer.cornerRadius = cell.imfSearchFriendEmailIds.frame.size.width / 2;
        cell.imfSearchFriendEmailIds.clipsToBounds = true;
        
         cell.btnInvite.layer.borderWidth = 0.8
        cell.btnInvite.layer.borderColor = UIColor.gray.cgColor
        if User[indexPath.row].IsInVited == "No"{
            cell.btnInvite.setTitle("Invite friend", for: .normal)
        }
        else{
            cell.btnInvite.setTitle("UnInvite friend", for: .normal)
        }
        cell.btnInvite.tag = indexPath.row
        cell.btnInvite.addTarget(self, action: #selector(self.SendInvite_UnIviteRequest(sender:)), for: UIControlEvents.touchUpInside)
        //EmailID = User[indexPath.row].emailId
        if User[indexPath.row].profileImage.hasPrefix("graph"){
            
            if let imageURL = URL(string: "https://"+User[indexPath.row].profileImage){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    
                    if let data = data{
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.imfSearchFriendEmailIds.image = image
                        }
                    }
                }
            }
        }else if(User[indexPath.row].profileImage.hasSuffix("jpg") || User[indexPath.row].profileImage.hasSuffix("jpeg")){
            if let imageURL = URL(string: User[indexPath.row].profileImage){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    
                    if let data = data{
                        let image = UIImage(data: data)
                        DispatchQueue.main.async
                            {
                            cell.imfSearchFriendEmailIds.image = image
                        }
                    }
                }
            }
        }
        else
        {
            if let imageURL = URL(string: "http://18.221.196.77/myworldapi/upload/defaultuserprofile.png"){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    
                    if let data = data{
                        let image = UIImage(data: data)
                        DispatchQueue.main.async
                            {
                                cell.imfSearchFriendEmailIds.image = image
                        }
                    }
                }
            }
        }
        return cell
    }
   

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85;
    }
    
    @objc func SendInvite_UnIviteRequest(sender: UIButton) -> Void{
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableviewcells)
        let indexPath = self.tableviewcells.indexPathForRow(at: buttonPosition)
        let cell = self.tableviewcells.cellForRow(at: indexPath!) as! SearchFriendTableViewCell
        if cell.btnInvite.titleLabel?.text! == "UnInvite friend"{
            self.unInvitefriendRequest(userID2:User[sender.tag].userId)
        }
        else{
            self.validatesendfriendRequest(sender:sender)
        }
    }
    
    func unInvitefriendRequest(userID2:String) {
        //self.activityindicator.startAnimating();
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        let urlToRequest = WEBSERVICE_URL+"unInvite.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+UserId+"&"+"userId2="+userID2
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
    
    
    @objc func validatesendfriendRequest(sender: UIButton) -> Void {
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        let buttonTag = sender.tag
        print(buttonTag)
        EmailID = User[buttonTag].emailId
        print(EmailID)
        let postData = NSMutableData(data: "userId=\(UserId)".data(using: String.Encoding.utf8)!)
        postData.append("&emailId=\(EmailID)".data(using: String.Encoding.utf8)!)
        SVProgressHUD.show(withStatus: "Loading")
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "sendfriendRequest.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                SVProgressHUD.dismiss()
            }else{
                
                print(data);
                SVProgressHUD.dismiss()
                if data .value(forKey: "responseCode") as! String == "200"{
                    SVProgressHUD.showSuccess(withStatus: data .value(forKey: "responseMessage") as? String)
                }else{
                    SVProgressHUD.showInfo(withStatus: data .value(forKey: "responseMessage") as? String)
                    
                }
                
            }
            
        })
    }
    
    

    

}
