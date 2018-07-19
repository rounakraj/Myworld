//
//  ProducatViewController.swift
//  MyWorld
//
//  Created by MyWorld on 17/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import Social
import Alamofire
import SVProgressHUD

class ProducatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet weak var checkCheckde: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddtoCart: UIButton!
    @IBOutlet weak var productImagesHeaderView: UIView!
    private var productlist = [ProductDetailsList]()
    private var productlist1 = [DetailsProdcat]()
    var isBoxclickde:Bool!
    var checkedimage = UIImage(named: "favred")
    var Uncheckedimage = UIImage(named: "grayheart")
    var height = 0
    var getProductId = String()
    var getuserName = String()
    var pickerNum = String()
    var userIdChat = String()
    var emailId = String ()
    var selectedQty = ""
    var lastQty = "Quantity"//"1"
    var images = [String]()
    let pickerItem = ["Quantity","1","2","3","4","5","6","7","8","10"]
    struct Storyboard {
        static let showShoeDetail = "ProductImagePageViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BottomViewController.sharedURLSessio.isHidden = true
        let productId: String = getProductId
        let userName: String = getuserName
        pickerNum = "1"
        if Reachability.shared.isConnectedToNetwork(){
            validateDetails(productId: productId,userName: userName)
            numberHits(productId:productId,userName:userName)
        }
        else{
            let alertController = UIAlertController(title: "My World", message: "Please check network", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if getuserName == "Myworld"{
             btnAddtoCart.isEnabled = true
             btnAddtoCart.setTitle("Add to Cart", for: .normal)
             //btnMakeAnOffer.isHidden = true
        }else{
            //btnMakeAnOffer.isHidden = false
             btnAddtoCart.isEnabled = true
            btnAddtoCart.setTitle("Make an Offer", for: .normal)
        }
    }
    
    @IBAction func pressBackButton(_ sender: Any) {
        navigationController?.popViewController(animated:true)
        BottomViewController.sharedURLSessio.isHidden = false
    }
    
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func btnAddtoCart(_ sender: Any) {
        if getuserName == "Myworld"
        {
            if pickerNum.isEmpty{
                
                let alertController = UIAlertController(title: "My World", message: "Please select Quantity", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                
                validateAddtoCart()
            }
        }
        else
        {
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            controller.userId2 = userIdChat
            controller.emailID = emailId
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
       
    }
    
    @IBAction func btnMakeAnOffer(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        controller.userId2 = userIdChat
        controller.emailID = emailId
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    @IBAction func btnWishlist(_ sender: Any) {
        
        if isBoxclickde == true{
            isBoxclickde = false
            
            validateRemoveWish(UserId:UserDefaults.standard.value(forKey: "userId") as! String,productId:getProductId,userName:getuserName)
        }else{
            isBoxclickde = true
            validateAddWishlist(UserId:UserDefaults.standard.value(forKey: "userId") as! String,productId:getProductId,userName:getuserName)
        }
        
        if isBoxclickde == true{
            
            checkCheckde.setImage(checkedimage, for: UIControlState.normal)
        }else{
            
            checkCheckde.setImage(Uncheckedimage, for: UIControlState.normal)
        }
    }
    
    
    @IBAction func btnChat(_sender: Any){
     
        if getuserName == "Myworld"
        {
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "AdminChatVC") as! AdminChatVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else {
    
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
             controller.userId2 = userIdChat
             controller.emailID = emailId
            self.navigationController?.pushViewController(controller, animated: true)
    
            
        }
    }
    
    
    
    func validateDetails(productId:String,userName:String) {
        //self.activityindicator.startAnimating();
        SVProgressHUD.show(withStatus: "Loading")
        let urlToRequest = WEBSERVICE_URL+"getproductDetail.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="productId="+productId+"&"+"userName="+userName
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            SVProgressHUD.dismiss()
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response ProductDetails\(String(describing: Data))") //JSONSerialization'
                
                let decoder = JSONDecoder()
               
                if self.getuserName == "Myworld"{
                    let  downloadproductlist1 = try decoder.decode(DetailsProdcats.self, from: data!)
                    self.productlist1 = downloadproductlist1.productlist
                       print(">>>>>>>>>>",self.productlist1[0].productImage1)
                    
                }else{
                    let  downloadproductlist = try decoder.decode(ProductDetailsLists.self, from: data!)
                    self.productlist = downloadproductlist.productlist
                }
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
            
                if responseCode==checkcode{
                    
                    DispatchQueue.main.async { // Correct
                       
                        if self.getuserName == "Myworld"{
                            self.images.append(self.productlist1[0].productImage1)
                            self.images.append(self.productlist1[0].productImage2)
                            self.images.append(self.productlist1[0].productImage3)
                            self.emailId = self.productlist1[0].emailId
                           
                        }else{
                            self.images.append(self.productlist[0].productImage1)
                            self.images.append(self.productlist[0].productImage2)
                            self.images.append(self.productlist[0].productImage3)
                            self.userIdChat = self.productlist[0].userId
                            self.emailId = self.productlist[0].emailId
                          
                        }
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
    

    
    func validateAddtoCart() {
        //self.activityindicator.startAnimating();
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        let urlToRequest = WEBSERVICE_URL+"addtoCart.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="productId="+getProductId+"&"+"userId="+UserId+"&"+"quantity="+pickerNum
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response ProductDetails\(String(describing: Data))") //JSONSerialization'
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                
                if responseCode==checkcode{
                    
                    DispatchQueue.main.async { // Correct
                        
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            // Do whatever you want with inputTextField?.text
                            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "CartListViewController") as! CartListViewController
                            self.navigationController?.pushViewController(desCV, animated: true)
                        })
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        
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
    
    
    
    func validateRemoveWish(UserId:String,productId:String,userName:String) {
        let userId = UserId
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"removeWish.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="productId="+productId+"&"+"userId="+userId+"&"+"userName="+userName
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
                print("*****ResponseWishlist \(String(describing: Data))") //JSONSerialization
                
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
    
    
    
    func validateAddWishlist(UserId:String,productId:String,userName:String) {
        let userId = UserId
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"addWishlist.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="productId="+productId+"&"+"userId="+userId+"&"+"userName="+userName
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
                print("*****ResponseWishlist \(String(describing: Data))") //JSONSerialization
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
                }
                else{
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
    
    
    func numberHits(productId:String,userName:String) {
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"numberHits.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="productId="+productId+"&"+"userName="+userName
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response ProductDetails\(String(describing: Data))") //JSONSerialization'
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    DispatchQueue.main.async { // Correct
                        
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
 

    @objc func mapViewTapped(){
        let lattiude = (self.productlist[0].latiTude as NSString).doubleValue
        let longitude = (self.productlist[0].longiTude as NSString).doubleValue
        self.openGoogleMap(lattitude:lattiude, longitude:longitude)
    }
    
    func openGoogleMap(lattitude:Double,longitude:Double){
        if (UIApplication.shared.canOpenURL(URL(string:"https://maps.google.com")!)) {
            UIApplication.shared.open(URL(string:"http://maps.google.com/?center=\(lattitude),\(longitude)&zoom=14&views=traffic&q=\(lattitude),\(longitude)")!, options: [:], completionHandler: nil)
        } else {
            print("Can't open")
        }
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if productlist1.count > 0 || productlist.count > 0 {
            return 1
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ProductDetailTVC()
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! ProductDetailTVC
            cell.updateCollection(array: images)
        }
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ProductDetailTVC
            cell.btnQty.addTarget(self, action: #selector(qtyAction(sender:)), for: .touchUpInside)
            cell.btnViewProfile.addTarget(self, action: #selector(viewProfileAction(sender:)), for: .touchUpInside)
            
            if getuserName == "Myworld"{
              cell.btnViewProfile.isHidden = true
            }else{
                cell.btnViewProfile.isHidden = false

            }
            
            cell.txtQty.addTarget(self, action: #selector(qtyAction(sender:)), for: UIControlEvents.editingDidBegin)
            //-- ravinder
            //cell.btnQty.setTitle("Quantity:" + lastQty, for: .normal)
            cell.btnQty.setTitle(self.lastQty, for: .normal)
            if self.getuserName == "Myworld"{ // For Admin
                cell.address.text = ""
                self.emailId = self.productlist1[0].emailId
                cell.lblProductName.text! = self.productlist1[0].productName
                cell.lblPercentage.text! = self.productlist1[0].Percent+"% Off"
                cell.lblInrPrice.text! = "INR "+self.productlist1[0].productPrice
                cell.lblProductSubName.text! = self.productlist1[0].brandName
                cell.lblProductSubCatName.text! = self.productlist1[0].brandmodelName

                let dateFormatter = DateFormatter()
                print(self.productlist1[0].productCreated)
                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: self.productlist1[0].productCreated) //according to date format your date string
                dateFormatter.dateFormat = "yyyy-MM-dd"
                cell.lblDate.text! =  dateFormatter.string(from: date!)
                cell.lblUploadbyName.text! = self.productlist1[0].userName
                cell.lblAddPosthours.text! = "Posted On: " + dateFormatter.string(from: date!)
            }
            else{ // For User
                cell.address.text = self.productlist[0].location
                self.userIdChat = self.productlist[0].userId
                self.emailId = self.productlist[0].emailId
                cell.lblProductName.text! = self.productlist[0].brandName
                cell.lblPercentage.text! = self.productlist[0].Percent+"% Off"
                cell.lblInrPrice.text! = "INR "+self.productlist[0].productPrice
                cell.lblDate.text! = self.productlist[0].productYear
                cell.lblUploadbyName.text! = self.productlist[0].userName
                cell.lblProductSubName.text! = self.productlist[0].brandName
                cell.lblProductSubCatName.text! = self.productlist[0].brandmodelName
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: self.productlist[0].productCreated) //according to date format your date string
                dateFormatter.dateFormat = "yyyy-MM-dd"
                cell.lblDate.text! =  dateFormatter.string(from: date!)
                cell.lblAddPosthours.text! = "Posted On: " + dateFormatter.string(from: date!)

            }
            
        }else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! ProductDetailTVC
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
            cell.mapImageView.addGestureRecognizer(tapGesture)
            cell.btnFb.addTarget(self, action: #selector(socialSharing(sender:)), for: .touchUpInside)
            cell.btnTwiter.addTarget(self, action: #selector(socialSharing(sender:)), for: .touchUpInside)
            cell.btnWhatsApp.addTarget(self, action: #selector(socialSharing(sender:)), for: .touchUpInside)
            if self.getuserName == "Myworld"{ //Admin
                cell.middleContainerView.isHidden = true
                cell.bottomViewTopConstraint.constant = -110
                cell.txtDiscription.text = self.productlist1[0].productDesp
                height = Int(self.productlist1[0].productDesp.height(withConstrainedWidth: self.view.frame.size.width-40, font: UIFont.systemFont(ofSize: 13)))
                print(height)
            }
            else{ //user
                cell.mapAddress.text = self.productlist[0].location
                cell.middleContainerView.isHidden = false
                cell.bottomViewTopConstraint.constant = 0
                cell.txtDiscription.text! = self.productlist[0].productDesp
                height = Int(self.productlist[0].productDesp.height(withConstrainedWidth: self.view.frame.size.width-40, font: UIFont.systemFont(ofSize: 13)))
                print(height)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 1{
            return 210
        }else if indexPath.section == 0{
            return 250
        }else{
            
            if self.getuserName == "Myworld"{
                if self.productlist1.count > 0 {
                    print("one")
                    return self.productlist1[0].productDesp.height(withConstrainedWidth: self.view.frame.size.width-60, font: UIFont.systemFont(ofSize: 13)) + 260
                }else{
                      print("two")
                    return 100

                }
                
            }else{
                if self.productlist.count > 0 {
                      print("three")
                    return self.productlist[0].productDesp.height(withConstrainedWidth: self.view.frame.size.width-60, font: UIFont.systemFont(ofSize: 13))+260
                   
                }else{
                      print("fourth")
                    return 100
                }
                
            }
        }
    }
    
    @objc func socialSharing(sender: UIButton) -> Void{
         var productName = String()
         var productImage = UIImage()
         if self.getuserName == "Myworld"{
            productName = self.productlist1[0].productName
            productImage = self.convertToImage(urlStr: self.productlist1[0].productImage1)
        }
         else{
          productName = self.productlist[0].brandName
          productImage = self.convertToImage(urlStr: self.productlist[0].productImage1)
        }
        YMSocialShare.shareOn(serviceType:.otherApps,text:productName,image:productImage)
    }
    
    func convertToImage(urlStr:String)->UIImage{
        let url = URL(string:urlStr)
        if let data = try? Data(contentsOf: url!){
            let image: UIImage = UIImage(data: data)!
            return image
        }
        return UIImage()
    }
    
    /*@objc func whatsAppAction(sender: UIButton) -> Void {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let urlString = "Sending WhatsApp message through app in Swift"
        let urlStringEncoded = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.openURL(url! as URL)
        } else {
            let errorAlert = UIAlertView(title: "Cannot Send Message", message: "Your device is not able to send WhatsApp messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
    
    @objc func facebookAction(sender: UIButton) -> Void {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Share on Facebook")
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func twitterAction(sender: UIButton) -> Void {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Share on Twitter")
            self.present(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }*/
    
    @objc func viewProfileAction(sender: UIButton) -> Void {
       
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        controller.userId = self.userIdChat;
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func qtyAction(sender: UITextField) -> Void {
        sender.tintColor = UIColor.clear
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        sender.inputView = pickerView
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self,
                                              action: #selector(self.doneClicked(sender:)))
        
        keyboardDoneButtonView.items = [doneButton]
        sender.inputAccessoryView = keyboardDoneButtonView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return pickerItem.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return  pickerItem[row]
       
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedQty = pickerItem[row]
        pickerNum = pickerItem[row]
    }
    
    
    @objc func doneClicked(sender: AnyObject) {
        
        if selectedQty.count < 1 {
            selectedQty = pickerItem[0]
            pickerNum = pickerItem[0]

        }
        lastQty = selectedQty
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
   
}

//2017-08-30
extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return  formatter.string(from: self as Date)
    }
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}


