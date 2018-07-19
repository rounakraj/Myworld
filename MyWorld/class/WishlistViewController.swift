//
//  WishlistViewController.swift
//  MyWorld
//
//  Created by MyWorld on 14/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD

class WishlistViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate{
    @IBOutlet weak var backgroundPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var lblBudge: UILabel!
    
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBAction func btnSearch(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SearchDetailItemVC") as! SearchDetailItemVC
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
    
    @IBAction func btnCart(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "CartListViewController") as! CartListViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    @IBOutlet weak var wishlistUICollectionView: UICollectionView!
    private var productlist = [WishlistList]()
    let pickerItem = ["1","2","3","4","5","6","7","8","10"]
    var pickerNum = String()
    var getproductId = String()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var cartList = [CartList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblBudge.isHidden=true

        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: 230)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        wishlistUICollectionView!.collectionViewLayout = layout
        
        validateWishlist(UserId: UserDefaults.standard.value(forKey: "userId") as! String)
        
        lblBudge.clipsToBounds = true
        lblBudge.layer.cornerRadius = lblBudge.frame.size.height/2
        lblBudge.layer.borderWidth = 0.8
        lblBudge.layer.borderColor = UIColor.clear.cgColor
        validateShowCart(UserId: UserDefaults.standard.value(forKey: "userId") as! String)
        pickerNum = "1"
    }
    @IBAction func backPress(_ sender: Any) {
        
        //self.navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated:true)
    }
    
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func btnDone(_ sender: Any) {
        
        backgroundPickerView.isHidden = true
        
        
    }
    
    
    @IBAction func btnCancel(_ sender: Any) {
        backgroundPickerView.isHidden = true
    }
    
    
    
    func validateWishlist(UserId:String) {
        SVProgressHUD.show(withStatus: "Loading")
        let userId = UserId

        let urlToRequest = WEBSERVICE_URL+"wishlist.php"
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
                SVProgressHUD.dismiss()
                DispatchQueue.main.async { // Correct
                    
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("***** \(String(describing: dataString))") //JSONSerialization
                    //self.activityindicator.stopAnimating();
                    
                }
            }
            
            do {
                SVProgressHUD.dismiss()
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseWishlist \(String(describing: Data))") //JSONSerialization
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadproductlist = try decoder.decode(WishlistLists.self, from: data!)
                    self.productlist = downloadproductlist.productlist
                    
                    
                    DispatchQueue.main.async { // Correct
                        
                        self.wishlistUICollectionView.reloadData()
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCollectionViewCell", for: indexPath) as! WishlistCollectionViewCell
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1).cgColor
        cell.contentView.layer.masksToBounds = true
        
        
        cell.btnDownButton.layer.cornerRadius = 5.0
        cell.btnDownButton.layer.borderWidth = 1.0
        cell.btnDownButton.layer.borderColor = UIColor.gray.cgColor
        cell.btnDownButton.layer.masksToBounds = true
        
        cell.lblWishlistProductName.text! = productlist[indexPath.row].productName
        cell.lblWishlistPrice.text! = productlist[indexPath.row].productPrice
        cell.lblWishlistUploadByName.text! = productlist[indexPath.row].userName
        cell.btnDownButton.addTarget(self, action: #selector(Openpicker), for: UIControlEvents.touchUpInside)
        cell.btnDislike.addTarget(self, action: #selector(validateRemoveWish), for: UIControlEvents.touchUpInside)
        cell.btnCart.addTarget(self, action: #selector(cartAction), for: UIControlEvents.touchUpInside)

        getproductId = productlist[indexPath.row].productId
       
        if let imageURL = URL(string: productlist[indexPath.row].productImage1){
            cell.imgWishlistImageview.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProducatViewController") as! ProducatViewController
        desCV.getProductId = productlist[indexPath.row].productId
        desCV.getuserName = productlist[indexPath.row].userName
        self.navigationController?.pushViewController(desCV, animated: true)
        
        
    }
    @objc func cartAction(sender: UIButton) {
        validateWishlist(UserId:UserDefaults.standard.value(forKey: "userId") as! String,productId: productlist[sender.tag].productId ,quantity: pickerNum)
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
    
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerItem.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerItem[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerNum = pickerItem[row]
        print(pickerNum)
    
    }
    
    
    @objc func Openpicker(){
        backgroundPickerView.isHidden = false
    }
    func validateWishlist(UserId:String,productId:String,quantity:String) {
        let userId = UserId
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"addtoCart.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="productId="+productId+"&"+"userId="+userId+"&"+"quantity="+quantity
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
                    
                    let decoder = JSONDecoder()
                    let  downloadproductlist = try decoder.decode(WishlistLists.self, from: data!)
                    self.productlist = downloadproductlist.productlist
                    
                    
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

    
    
    
    @objc func validateRemoveWish(sender: UIButton) {
        let userName = productlist[sender.tag].userName
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"removeWish.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="productId="+getproductId+"&"+"userId="+userId+"&"+"userName="+userName
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
                    
                    let decoder = JSONDecoder()
                    let  downloadproductlist = try decoder.decode(WishlistLists.self, from: data!)
                    self.productlist = downloadproductlist.productlist
                    
                    
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
                            
                            self.lblBudge.text = String(self.cartList.count)
                            self.lblBudge.isHidden=false
                        }else{
                            self.lblBudge.isHidden=true
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
