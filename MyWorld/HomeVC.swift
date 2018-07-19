//
//  HomeVC.swift
//  MyWorld
//
//  Created by Shankar Kumar on 15/02/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift

class HomeVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var budge: UILabel!
    @IBOutlet weak var btnMenuButton: UIButton!

    private var brandList = [FutureBrand]()

    private var productUser2 = [SellProductList]()
    private var productUser1 = [SellProductList]()
    private var recentList = [RecentChatList]()
    private var friendList = [OnlineFriends]()
    var cartList = [CartList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        BootomBar.shared.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        if (UserDefaults.standard.value(forKey: "EmailId") != nil) {
            NotificationManager.sharedController().initSinchClient(withUserId:UserDefaults.standard.value(forKey: "EmailId") as! String)
            
        }
        
        
        btnMenuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        
        
        budge.clipsToBounds = true
        budge.layer.cornerRadius = budge.frame.size.height/2
        budge.layer.borderWidth = 0.8
        budge.layer.borderColor = UIColor.clear.cgColor
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.sharedManager().enable = true

        BootomBar.shared.showBootomBar()
        self.budge.isHidden=true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        BootomBar.shared.hideBootomBar()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        validateFutureBrand()
        validateNearbyProduct()
        validateShowRecentchat()
        validateOnLonegetFriends()
        validateShowCart()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 1

    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = HomeTVC()
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! HomeTVC
            
            
            
        }else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! HomeTVC
            cell.productCollectionView.layer.cornerRadius = 2.0
            cell.productCollectionView.layer.borderWidth = 1.0
            cell.productCollectionView.layer.borderColor = UIColor.clear.cgColor
            cell.productCollectionView.layer.masksToBounds = true
            
            cell.updateProduct(brandListdata: brandList)
            
        }else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! HomeTVC

                
        
        }else if indexPath.section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! HomeTVC
            cell.nearByCollectionView.layer.cornerRadius = 5.0
            cell.nearByCollectionView.layer.borderWidth = 1.0
            cell.nearByCollectionView.layer.borderColor = UIColor.clear.cgColor
            cell.nearByCollectionView.layer.masksToBounds = true
            cell.updateNearBy(productUserData: productUser2)

            
        }else if indexPath.section == 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! HomeTVC

        }else if indexPath.section == 5 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! HomeTVC
            
            cell.chatCollectionView.layer.cornerRadius = 5.0
            cell.chatCollectionView.layer.borderWidth = 1.0
            cell.chatCollectionView.layer.borderColor = UIColor.clear.cgColor
            cell.chatCollectionView.layer.masksToBounds = true
            //cell.recentBtn.addTarget(self, action: #selector(recentAction(sender:)), for: .touchUpInside)

            cell.updateChat(recentListData: recentList)

            
        }else if indexPath.section == 6 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! HomeTVC
            
            cell.nearByView1.layer.cornerRadius = 5.0
            cell.nearByView1.layer.borderWidth = 1.0
            cell.nearByView1.layer.borderColor = UIColor.clear.cgColor
            cell.nearByView1.layer.masksToBounds = true
            
            cell.nearByView.layer.cornerRadius = 5.0
            cell.nearByView.layer.borderWidth = 1.0
            cell.nearByView.layer.borderColor = UIColor.clear.cgColor
            cell.nearByView.layer.masksToBounds = true
            cell.updateOnline(friendListData: friendList)

            cell.userProfileImage.clipsToBounds = true
            cell.userProfileImage.layer.cornerRadius = cell.userProfileImage.frame.size.height/2
            cell.userProfileImage.layer.borderWidth = 0.8
            cell.userProfileImage.layer.borderColor = UIColor.clear.cgColor
            
            cell.updateStatusBtn.addTarget(self, action: #selector(btnNewPost(_:)), for: .touchUpInside)
            cell.myPageBtn.addTarget(self, action: #selector(btnMyPost(_:)), for: .touchUpInside)
            cell.onlineBtn.addTarget(self, action: #selector(recentAction(sender:)), for: .touchUpInside)

            let profileImg = UserDefaults.standard.value(forKey: "profileImage") as! String
            if profileImg.hasPrefix("graph"){
                print("Facebook Graph")
                if profileImg.hasPrefix("https"){
                    print("Facebook with https")
                    if let imageURL = URL(string: profileImg){
                        cell.userProfileImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                    }
                }
                else{
                    print("Facebook without https")
                    if let imageURL = URL(string: "https://"+profileImg){
                        cell.userProfileImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                    }
                }
            }else if(profileImg.hasSuffix("jpg") || profileImg.hasSuffix("jpeg")){
                if let imageURL = URL(string: profileImg){
                    cell.userProfileImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                }
            }
            else
            {
                /*if let imageURL = URL(string: "http://18.221.196.77/myworldapi/upload/defaultuserprofile.png"){
                    cell.userProfileImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                }*/
                  cell.userProfileImage.sd_setImage(with: URL(string: profileImg), placeholderImage:  UIImage(named: "ic_profile"))
            }
        }
        
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 136
        }else if indexPath.section == 1 {
            return 144
        }else if indexPath.section == 2 {
            return 132
        }else if indexPath.section == 3 {
            return 154
        }else if indexPath.section == 4 {
            return 128
        }else if indexPath.section == 5 {
            return 133
        }else{
            return 250
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section == 0 {
             print("I am CLicked  0\n")
            btnBuyButton(self)

        }else if indexPath.section == 1 {
             print("I am CLicked 1\n")
            
        }else if indexPath.section == 2 {
             print("I am CLicked 2\n")
            btnSellButton(self)

        }else if indexPath.section == 3 {
             print("I am CLicked 3\n")
            
        }else if indexPath.section == 4 {
            print("I am CLicked 4\n")
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController") as! FriendsListViewController
            self.navigationController?.pushViewController(desCV, animated: true)
            
        }else if indexPath.section == 5 {
             print("I am CLicked 5\n")
            
        }else{
            
        }
    }
    
    @objc func recentAction(sender: UIButton) -> Void {
        print("Recent Action I am CLicked\n")
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController") as! FriendsListViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    

    @IBAction func btnSearAction(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SearchDetailItemVC") as! SearchDetailItemVC
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    @objc func btnNewPost(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "NewPostViewController") as! NewPostViewController
        desCV.from = "0"
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    @IBAction func btnCart(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "CartListViewController") as! CartListViewController
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
    
    @IBAction func btnHomeButton(_ sender: Any) {
        
        
    }
    
    @objc func btnMyPost(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "MyPosts") as! MyPosts
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    @IBAction func btnBuyButton(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "BuyViewController") as! BuyViewController
        self.navigationController?.pushViewController(desCV, animated: true)
        
        
    }
    
    
    
    
    @IBAction func btnSellButton(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SellUiViewController") as! SellUiViewController
        self.navigationController?.pushViewController(desCV, animated: true)
        
        
    }
    @IBAction func btnWishlist(_ sender: Any) {
        
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
        // Add View Controller as Child View Controller
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func validateFutureBrand() {
        
        SVProgressHUD.show(withStatus: "Loading")
        
        let urlToRequest = WEBSERVICE_URL+"getFeature.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString=""
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                SVProgressHUD.dismiss()
                
                return
            }
            SVProgressHUD.dismiss()
            
            if let data = data {
                DispatchQueue.main.async { // Correct
                    
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("***** \(String(describing: dataString))") //JSONSerialization
                    
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
                    let  downloadBrandList = try decoder.decode(BrandList.self, from: data!)
                    
                    self.brandList = downloadBrandList.brandList
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
    
    
    func validateNearbyProduct() {
        let urlToRequest = WEBSERVICE_URL+"getnearbyProduct.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userLat="+"28.7041"+"&"+"userLong="+"77.1025"
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadBrandList = try decoder.decode(SellProductList1.self, from: data!)
                    self.productUser2 = downloadBrandList.productUser2
                    let  downloadBrandLists = try decoder.decode(SellProductList2.self, from: data!)
                    self.productUser1 = downloadBrandLists.productUser1
                    
                    self.productUser2.append(contentsOf: self.productUser1)
                    
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
                
            }
            
        }
        
        task.resume()
    }
    
    
    func validateShowRecentchat() {
        let UserId = UserDefaults.standard.value(forKey: "userId") as? String
        let urlToRequest = WEBSERVICE_URL+"showRecentchat.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+UserId!
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    
                    let decoder = JSONDecoder()
                    let  downloadrecentList = try decoder.decode(RecentChat.self, from: data!)
                    self.recentList = downloadrecentList.recentList
                    
                    
                    DispatchQueue.main.async { // Correct
                        
                        self.tableView.reloadData()
                    }
                    
                }else{
                    
//                    let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
//                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alertController.addAction(defaultAction)
//                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }
    
    
    func validateOnLonegetFriends() {
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        let urlToRequest = WEBSERVICE_URL+"getFriends.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+UserId
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    
                    let decoder = JSONDecoder()
                    let  downloadfriendList = try decoder.decode(OnlineFriend.self, from: data!)
                    self.friendList = downloadfriendList.friendList
                    
                    
                    DispatchQueue.main.async { // Correct
                        
                        self.tableView.reloadData()
                    }
                    
                    
                }else{
                    
//                    let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
//                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alertController.addAction(defaultAction)
//                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }
    
    
    func validateShowCart() {
        
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"showCart.php"
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
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                //let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadcartList = try decoder.decode(CartLists.self, from: data!)
                    self.cartList = downloadcartList.cartList
                    
                    DispatchQueue.main.async { // Correct
                        
                        if self.cartList.count > 0{
                            
                            self.budge.text = String(self.cartList.count)
                            self.budge.isHidden=false
                        }else{
                            self.budge.isHidden=true
                        }
                        
                    }
                }
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }
}




extension HomeVC:MenuDelegate{
    
    func didSelecte(index: NSInteger) {
        
        if index == 0
        {
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "PostAddViewController") as! PostAddViewController
            self.navigationController?.pushViewController(desCV, animated: true)
            
        }
        if index == 1
        {
            
            print("Home Tapped")
            self.viewDidAppear(true)
        }
        
        if index == 2
        {
            
            print("My Account")
            
            let mainStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
            let desController=mainStoryboard.instantiateViewController(withIdentifier: "MyAccountViewController")as!MyAccountViewController
            self.navigationController?.pushViewController(desController, animated: true)
            
        }
        
        if index == 3
        {
            print("Refer & Earn")
            
            let mainStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
            let desController=mainStoryboard.instantiateViewController(withIdentifier: "MyRewardsViewController")as!MyRewardsViewController
            self.navigationController?.pushViewController(desController, animated: true)
            
        }
        if index == 4
        {
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController") as! FriendsListViewController
            self.navigationController?.pushViewController(desCV, animated: true)
        }
        if index == 5
        {
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as! OrderHistoryViewController
            self.navigationController?.pushViewController(desCV, animated: true)
        }
        
        if index == 6
        {
            print("Address Book")
            
            let mainStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
            let desController=mainStoryboard.instantiateViewController(withIdentifier: "AdressViewController")as!AdressViewController
            self.navigationController?.pushViewController(desController, animated: true)
            
        }
        if index == 7
        {
            print("Browse Category")
            
            let mainStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
            let desController=mainStoryboard.instantiateViewController(withIdentifier: "BrowseCategoryViewController")as!BrowseCategoryViewController
            self.navigationController?.pushViewController(desController, animated: true)
            
        }
        
        if index == 8
        {
            print("Terms & Conditions")
            
            let mainStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
            let desController=mainStoryboard.instantiateViewController(withIdentifier: "TermsConditonViewController")as!TermsConditonViewController
            self.navigationController?.pushViewController(desController, animated: true)
            
        }
        
        if index == 9
        {
            
            print("Contact Us")
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ContactusViewController") as! ContactusViewController
            self.navigationController?.pushViewController(desCV, animated: true)
            
        }
        if index == 10
        {
            print("LoginViewController")
            UserDefaults.standard.removeObject(forKey: "userId")
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(desCV, animated: true)
        }
        if index == 15
        {
            print("ProfileViewController")
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            desCV.userId =   UserDefaults.standard.value(forKey: "userId") as! String
            self.navigationController?.pushViewController(desCV, animated: true)
        }
        
    }
    
    
    
}
extension HomeVC:RecentChatProtocol{

    func openRecentChat(userid: String, email: String) {
        print("openRecentChat")
        print(String(userid))
        print(String(email))
        IQKeyboardManager.sharedManager().enable = false
     
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        controller.userId2 = userid
        controller.emailID = email
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openNearBuyItem(productid: String, userName: String) {
        print("openNearBuyItem")
        print(String(productid))
        print(String(userName))
        
        IQKeyboardManager.sharedManager().enable = false
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProducatViewController") as! ProducatViewController
        desCV.getProductId = productid
        desCV.getuserName = userName
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    func openBuyPage(){
        print("openBuyPage")
        IQKeyboardManager.sharedManager().enable = false
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "BuyViewController") as! BuyViewController
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
    
    
    
}

extension HomeVC:BootomDelegate{
   
    func myContactClicked() {
        BootomBar.shared.hideBootomBar()
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController") as! FriendsListViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func myCrossClicked() {
        BootomBar.shared.hideBootomBar()
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "CommingSoon") as! CommingSoon
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getImage(imageData: NSData) {
        BootomBar.shared.hideBootomBar()
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "SelectFriendsViewController") as! SelectFriendsViewController
        controller.imageData = imageData
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func getVideoesData(videoesData: NSData,thumb_nail:NSData) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "SelectFriendsViewController") as! SelectFriendsViewController
        controller.videoesData = videoesData
        controller.thumb_nail = thumb_nail
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func chatClicked() {
        debugPrint("chatClicked")
        BootomBar.shared.hideBootomBar()
        IQKeyboardManager.sharedManager().enable = false

        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ChatFriendViewController") as! ChatFriendViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    func cameraClicked() {
        debugPrint("cameraClicked")
        let alertView = UIAlertController(title: "Choose Option", message: "Add a picture", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            BootomBar.shared.shootPhoto(controller: self)
        })
        let library = UIAlertAction(title: "Library", style: .default, handler: { (alert) in
            BootomBar.shared.photoFromLibrary(controller: self)
        })
        let recordVideo = UIAlertAction(title: "Record Video", style: .default, handler: { (alert) in
            BootomBar.shared.recordingVideo(controller: self)
            
        })
        let uploadVideo = UIAlertAction(title: "Upload Video", style: .default, handler: { (alert) in
            BootomBar.shared.videoFromLibrary(controller: self)
            
        })
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            
        })
        alertView.addAction(camera)
        alertView.addAction(library)
        alertView.addAction(recordVideo)
        alertView.addAction(uploadVideo)
        alertView.addAction(Cancel)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func myPostClicked() {
        debugPrint("myPostClicked")
        BootomBar.shared.hideBootomBar()
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "MyPosts") as! MyPosts
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
