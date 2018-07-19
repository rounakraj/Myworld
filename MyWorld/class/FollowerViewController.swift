//
//  FollowerViewController.swift
//  MyWorld
//
//  Created by MyWorld on 11/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class FollowerViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
@IBOutlet weak var tablbleview: UITableView!
    private var followersList = [Following]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validateGetFollowers(UserId: UserDefaults.standard.value(forKey: "userId") as! String)
    }

    @IBAction func btnBackPress(_ sender: Any) {
        
        navigationController?.popViewController(animated:true)
    }
    
    func validateGetFollowers(UserId:String) {
        let userId=UserId
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"getFollowers.php"
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
                    let  downloadfollowersList = try decoder.decode(Follwer.self, from: data!)
                    self.followersList = downloadfollowersList.followersList
                    DispatchQueue.main.async { // Correct
                        
                        self.tablbleview.reloadData()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return followersList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersTableViewCell")as? FollowersTableViewCell else{ return UITableViewCell ()}
        
        let firstName = followersList[indexPath.row].firstName
        let lastName = followersList[indexPath.row].lastName
        cell.lblFollowerFrName.text = firstName+" "+lastName
        cell.imgFollowerimaigeview.layer.cornerRadius = cell.imgFollowerimaigeview.frame.size.width / 2;
        cell.imgFollowerimaigeview.clipsToBounds = true;
        
        
        if (followersList[indexPath.row].profileImage.hasPrefix("graph")){
            if let imageURL = URL(string: "https://"+followersList[indexPath.row].profileImage){
                cell.imgFollowerimaigeview.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "ic_profile"))
            }
        }else{
            cell.imgFollowerimaigeview.sd_setImage(with: URL(string: followersList[indexPath.row].profileImage), placeholderImage: UIImage(named: "ic_profile"))
        }
        
        
        return cell
    }
    

}
