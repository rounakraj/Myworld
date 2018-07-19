//
//  MainViewController.swift
//  MyWorld
//
//  Created by MyWorld on 05/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD


class MainViewController: UIViewController,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var typeHeare: UIView!
    @IBOutlet weak var budge: UILabel!
    
    var imageData = NSData()
    let picker = UIImagePickerController()
    var cartList = [CartList]()
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var imgeHome: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewNearby: UIView!
    @IBOutlet weak var viewRecentchat: UIView!
    @IBOutlet weak var btnMenuButton: UIButton!
    @IBOutlet weak var NearByPlaceCallectionViewCell: UICollectionView!
    @IBOutlet weak var OfferCollectionViewCell: UICollectionView!
    @IBOutlet weak var RecentChatCollectionViewCell: UICollectionView!
    @IBOutlet weak var OnlineFriendsCollectionView: UICollectionView!
    private var brandList = [FutureBrand]()
    private var productUser2 = [SellProductList]()
    private var productUser1 = [SellProductList]()
    private var recentList = [RecentChatList]()
    private var friendList = [OnlineFriends]()

    override func viewDidLoad() {
        super.viewDidLoad()
            BootomBar.shared.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        if (UserDefaults.standard.value(forKey: "EmailId") != nil) {
            NotificationManager.sharedController().initSinchClient(withUserId:UserDefaults.standard.value(forKey: "EmailId") as! String)
        }
        
        
        btnMenuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        
        
        viewNearby.layer.cornerRadius=7
        viewRecentchat.layer.cornerRadius=7
        typeHeare.layer.cornerRadius=7
        
        budge.clipsToBounds = true
        budge.layer.cornerRadius = budge.frame.size.height/2
        budge.layer.borderWidth = 0.8
        budge.layer.borderColor = UIColor.clear.cgColor
       
        
        OfferCollectionViewCell.delegate=self
        OfferCollectionViewCell.dataSource=self
        
        NearByPlaceCallectionViewCell.delegate=self
        NearByPlaceCallectionViewCell.dataSource=self
        
        RecentChatCollectionViewCell.delegate=self
        RecentChatCollectionViewCell.dataSource=self
        
        OnlineFriendsCollectionView.delegate=self
        OnlineFriendsCollectionView.dataSource=self
        
        
        imgeHome.layer.cornerRadius = imgeHome.frame.size.width / 2;
        imgeHome.clipsToBounds = true;
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(btnNewPost(_:)))
        tap.delegate = self
        typeHeare.addGestureRecognizer(tap)
        self.typeHeare.isUserInteractionEnabled = true
        
        
        let profileImg = UserDefaults.standard.value(forKey: "profileImage") as! String
        if profileImg.hasPrefix("graph"){
            
            if let imageURL = URL(string: "https://"+profileImg){
                self.imgeHome.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
        }else if(profileImg.hasSuffix("jpg") || profileImg.hasSuffix("jpeg")){
            if let imageURL = URL(string: profileImg){
                self.imgeHome.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
        }
        else{
            if let imageURL = URL(string: "http://18.221.196.77/myworldapi/upload/defaultuserprofile.png"){
                self.imgeHome.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1180)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        validateFutureBrand()
        validateNearbyProduct()
        validateShowRecentchat(UserId: UserDefaults.standard.value(forKey: "userId") as! String)
        validateOnLonegetFriends(UserId: UserDefaults.standard.value(forKey: "userId") as! String)
        validateShowCart(UserId: UserDefaults.standard.value(forKey: "userId") as! String)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        BootomBar.shared.showBootomBar()
        self.budge.isHidden=true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        BootomBar.shared.hideBootomBar()
        
    }
    @IBAction func btnSearAction(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SearchDetailItemVC") as! SearchDetailItemVC
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    @IBAction func btnNewPost(_ sender: Any) {
        
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
    
    @IBAction func btnMyPost(_ sender: Any) {
        
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
    
    
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return brandList.count
    
        if collectionView==self.OfferCollectionViewCell{
            
            return brandList.count
            
            
        }else if collectionView==self.NearByPlaceCallectionViewCell{
            
            return productUser2.count
            
        }else if collectionView==self.RecentChatCollectionViewCell{
            
            return recentList.count
            
        }else {
            
            return friendList.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView==self.OfferCollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCollectionViewCell", for: indexPath) as! OfferCollectionViewCell
            
        cell.lblOfferName.text! = brandList[indexPath.row].brandName
            
            if let imageURL = URL(string:brandList[indexPath.row].brandImage){
                cell.imageOffer.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
        
        return cell
        }else if collectionView==self.NearByPlaceCallectionViewCell{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearByPlaceCollectionViewCell", for: indexPath) as! NearByPlaceCollectionViewCell
            cell.lblNearName.text! = productUser2[indexPath.row].productName
            
            if let imageURL = URL(string:productUser2[indexPath.row].productImage1){
                cell.imageOffer.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
        
            return cell
            
        }else if collectionView==self.RecentChatCollectionViewCell{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentChatCollectionViewCell", for: indexPath) as! RecentChatCollectionViewCell

            cell.lblRecentChatName.text! = recentList[indexPath.row].userName
            cell.imageRecentChat.layer.cornerRadius = cell.imageRecentChat.frame.size.width / 2;
            cell.imageRecentChat.clipsToBounds = true;
            
            if recentList[indexPath.row].profileImage.hasPrefix("graph"){
                
                if let imageURL = URL(string: "https://"+recentList[indexPath.row].profileImage){
                    cell.imageRecentChat.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
                }
            }else if (recentList[indexPath.row].profileImage.hasSuffix("jpg") || recentList[indexPath.row].profileImage.hasSuffix("jpeg")){
                if let imageURL = URL(string: recentList[indexPath.row].profileImage){
                    cell.imageRecentChat.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
                }
            }
            else
            {
                if let imageURL = URL(string: "http://18.221.196.77/myworldapi/upload/defaultuserprofile.png"){
                    cell.imageRecentChat.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
                }
            }
            
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnlineFriendsCollectionViewCell", for: indexPath) as! OnlineFriendsCollectionViewCell
            
            cell.lblOnlineFriendsName.text! = friendList[indexPath.row].firstName
            cell.ImageOnline.layer.cornerRadius = cell.ImageOnline.frame.size.width / 2;
            cell.ImageOnline.clipsToBounds = true;
            
        
            if friendList[indexPath.row].profileImage.hasPrefix("graph"){
                
                if let imageURL = URL(string: "https://"+friendList[indexPath.row].profileImage){
                    cell.ImageOnline.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
                }
            }else if (friendList[indexPath.row].profileImage.hasSuffix("jpg") || friendList[indexPath.row].profileImage.hasSuffix("jpeg")){
                if let imageURL = URL(string: "http://18.221.196.77/myworldapi/upload/defaultuserprofile.png"){
                    cell.ImageOnline.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
                }
            }
            
            
            return cell
        }
        
        
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
                        
                        self.OfferCollectionViewCell.reloadData()
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
                        
                        self.NearByPlaceCallectionViewCell.reloadData()
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
    
    
    func validateShowRecentchat(UserId:String) {
        let urlToRequest = WEBSERVICE_URL+"showRecentchat.php"
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
                    let  downloadrecentList = try decoder.decode(RecentChat.self, from: data!)
                    self.recentList = downloadrecentList.recentList
                    
                    
                    DispatchQueue.main.async { // Correct
                        
                        self.RecentChatCollectionViewCell.reloadData()
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
    
    
    func validateOnLonegetFriends(UserId:String) {
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
                        
                        self.OnlineFriendsCollectionView.reloadData()
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

    
    func validateShowCart(UserId:String) {
        let userId = UserId
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
    
    
    @IBAction func offersBannerAction(_ sender: Any) {
        btnBuyButton(sender)
    }
    @IBAction func offerBannerTwoAction(_ sender: Any) {
        btnSellButton(sender)
    }
    
    @IBAction func socialBannerAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController") as! FriendsListViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
}

extension MainViewController:MenuDelegate{

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
           
            print("Contact us")
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ContactusViewController") as! ContactusViewController
            self.navigationController?.pushViewController(desCV, animated: true)
            
        }
        if index == 10
        {
            print("Logout")
            UserDefaults.standard.removeObject(forKey: "userId")
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(desCV, animated: true)
        }
        if index == 15
        {
            print("Profile")
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            desCV.userId =   UserDefaults.standard.value(forKey: "userId") as! String
            self.navigationController?.pushViewController(desCV, animated: true)
        }
        
    }
    
   
    
}

extension MainViewController:BootomDelegate{
    func myContactClicked() {
        BootomBar.shared.hideBootomBar()
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController") as! FriendsListViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func myCrossClicked() {
        BootomBar.shared.hideBootomBar()
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "SelectFriendsViewController") as! SelectFriendsViewController
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
