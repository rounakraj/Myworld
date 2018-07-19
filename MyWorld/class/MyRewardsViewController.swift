//
//  MyRewardsViewController.swift
//  MyWorld
//
//  Created by MyWorld on 07/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class MyRewardsViewController: UIViewController,UITableViewDataSource{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableviewCell: UITableView!
    @IBOutlet weak var Points: UILabel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var totalPoints: UILabel!
    @IBOutlet weak var totalFriends: UILabel!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    struct rewardsVariable {
        static var rewardEmail = ""
    }
    private var referList = [MyreferList]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnMenuButton.target=revealViewController()
        btnMenuButton.action=#selector(SWRevealViewController.revealToggle(_:))
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = true;
        getuserProfile(UserId: UserDefaults.standard.value(forKey: "userId") as! String)

    }

    override func viewDidAppear(_ animated: Bool) {
        
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1000000015, green: 0.3860000074, blue: 0.7459999919, alpha: 1)
        validategetMyrefer(UserId: UserDefaults.standard.value(forKey: "userId") as! String)
        segmentControl.selectedSegmentIndex = 0
        segmentAction(segmentControl)
    }
    @IBAction func pressMe(_ sender: Any) {
        
        print("call press button")

    }
    
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            scrollView.isHidden = true
            tableviewCell.isHidden = false

        }else{
            scrollView.isHidden = false
            tableviewCell.isHidden = true
        }
    }
    @IBAction func termsAction(_ sender: Any) {
        let mainStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
        let desController=mainStoryboard.instantiateViewController(withIdentifier: "TermsConditonViewController")as!TermsConditonViewController
        self.navigationController?.pushViewController(desController, animated: true)
        
    }
    @IBAction func backPress(_ sender: Any) {
        
        navigationController?.popViewController(animated:true)
    }
    
    @IBAction func btnShareInvite(_ sender: Any) {
        // MARK: - Helper Methods
        print("Myworld Share Option\n\n")
        let emailID = rewardsVariable.rewardEmail
        print("EmailID: \(emailID)")
        let msgString = String(format: "Hey,\n Check out My World application. \nhttps://play.google.com/store/apps/details?id=com.app.shopchatmyworldra \n Invitee Email: %@",emailID )
        print("MsgString: \(msgString)")
        let attachment = (data: UIImagePNGRepresentation(#imageLiteral(resourceName: "logo")),fileName:"logo.png")
        YMSocialShare.shareOnMessanger(recipients:"","", subject:"MyWorld Invite", body:msgString ,attachment:attachment)
    }
    
    @IBAction func pressInviteFriends(_ sender: Any) {
        
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        print("call press Invite friends")

    }
    
    func getuserProfile(UserId:String) {
        let userId=UserId
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
                   
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                
                DispatchQueue.main.async { // Correct
                    let  profileImage = Data["profileImage"] as? String
                    rewardsVariable.rewardEmail = (Data["emailId"] as? String)!
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
                                        self.imageView.image = image
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
                    
                }
                
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }
    
    func validategetMyrefer(UserId:String) {
        let userId=UserId
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"getMyrefer.php"
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
                   // self.activityindicator.stopAnimating();
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseMyRewords \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadreferList = try decoder.decode(MyreferLists.self, from: data!)
                    self.referList = downloadreferList.referList
                    
                    DispatchQueue.main.async { // Correct
                        self.totalPoints.text=Data["earn"] as? String
                        self.totalFriends.text=Data["totalRefer"] as? String
                        self.tableviewCell.reloadData()
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
        
        return referList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyRewardsTVC")as? MyRewardsTVC else{ return UITableViewCell ()}
        
        cell.txtName.text = referList[indexPath.row].firstName
        //cell.txtEarn.text = friendlist[indexPath.row].emailId
      
    
        return cell
    }
    
    
    // MARK: - Helper Methods
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }

}
