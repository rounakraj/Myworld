//
//  CartListViewController.swift
//  MyWorld
//
//  Created by MyWorld on 01/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class CartListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate{
    @IBOutlet weak var tableViewCell: UITableView!

    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var btnProceed: UIButton!
    
    var selectedText = UITextField()

    var StringBuilder = String()
    var StringBuilder1 = String()
    var price = String()
    var cartList = [CartList]()
    var cartId = String()
    var productId = String()
    var Name = String()
    var pickerNum = String()
    var position = Int ()
    let pickerItem = ["1","2","3","4","5","6","7","8","10"]
    @IBAction func backPress(_ sender: Any) {
        navigationController?.popViewController(animated:true)
        //self.navigationController?.isNavigationBarHidden = false
         BottomViewController.sharedURLSessio.isHidden = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //self.navigationController?.isNavigationBarHidden = true
        tableViewCell.dataSource = self
        tableViewCell.delegate = self
        BottomViewController.sharedURLSessio.isHidden = true
        validateShowCart(UserId: UserDefaults.standard.value(forKey: "userId") as! String)
        
    }
  
    
    
    @IBAction func btnProceed(_ sender: Any) {
        
        for word in cartList {
            print(">>>>>>>>",word.cartId)
            
            StringBuilder.append(word.cartId);
            StringBuilder.append(",");

        }
        
        StringBuilder = StringBuilder.substring(to: StringBuilder.index(before: StringBuilder.endIndex))

        PaymentDetailData.shared.cartID = StringBuilder
        PaymentDetailData.shared.totalPrice = price

        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "AddressDeliverViewController") as! AddressDeliverViewController
        
        self.navigationController?.pushViewController(desCV, animated: true)
      
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
                    print("***** \(String(describing: dataString))") //
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    self.btnProceed.isHidden = false

                    let decoder = JSONDecoder()
                    let  downloadcartList = try decoder.decode(CartLists.self, from: data!)
                    self.cartList = downloadcartList.cartList
                    let price =  Data["totalsplPrice"] as? String
                    DispatchQueue.main.async { // Correct
                       
                        self.tableViewCell.reloadData()
                        self.lblTotalPrice.text = "Total Price:-"+" "+price!
                        self.price = (Data["totalsplPrice"] as? String)!
                    }
                }else{
                    self.btnProceed.isHidden = true
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
        
        return cartList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartListTableViewCell")as? CartListTableViewCell else{ return UITableViewCell ()}
        
        cell.lblProductName.text = cartList[indexPath.row].productName
        cell.lblPrice.text = "Price: "+cartList[indexPath.row].singlePrice
        cell.lblSpecialPrice.text = "Special price: "+cartList[indexPath.row].singlesplPrice
        cell.txtQty.text = "Quantity: " + cartList[indexPath.row].quantity
        
        cell.btnWishlist.layer.borderWidth = 0.8
        cell.btnWishlist.layer.borderColor = UIColor.gray.cgColor
        cell.btnRemove.layer.borderWidth = 0.8
        cell.btnRemove.layer.borderColor = UIColor.gray.cgColor
        cell.btnRemove.addTarget(self, action: #selector(validateRemoveCart), for: UIControlEvents.touchUpInside)
        cartId = cartList[indexPath.row].cartId
        position = indexPath.row
        cell.btnWishlist.addTarget(self, action: #selector(validateAddWishlist), for: UIControlEvents.touchUpInside)
        productId = cartList[indexPath.row].productId
        Name = cartList[indexPath.row].userName
        if let imageURL = URL(string: cartList[indexPath.row].productImage1){
            cell.imgCartList.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))

        }
        cell.txtQty.addTarget(self, action: #selector(qtyAction(sender:)), for: UIControlEvents.editingDidBegin)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 190;
    }
    
    @objc func validateRemoveCart() {
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"removeCart.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+UserId+"&"+"cartId="+cartId
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
                        self.cartList.remove(at: self.position)
                        self.tableViewCell.reloadData()
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

    @objc func validateAddWishlist() {
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"addWishlist.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+UserId+"&"+"productId="+productId+"&"+"userName="+Name
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
                    let  downloadcartList = try decoder.decode(CartLists.self, from: data!)
                    self.cartList = downloadcartList.cartList
                    DispatchQueue.main.async { // Correct
                        
                        self.tableViewCell.reloadData()
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
   
     func validateEditCart() {
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"editCart.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+UserId+"&"+"cartId="+cartId+"&"+"quantity="+pickerNum
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
                    
                    let price =  Data["totalsplPrice"] as? String
                    DispatchQueue.main.async { // Correct
                        
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        self.price = (Data["totalsplPrice"] as? String)!
                        self.lblTotalPrice.text = "Total Price:-"+" "+price!
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
            selectedText.text = "Quantity: " + pickerItem[row]

    }
    
    
    
    
    @objc func qtyAction(sender: UITextField) -> Void {
        selectedText = sender
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
    @objc func doneClicked(sender: AnyObject) {
        
        if (selectedText.text?.count)! < 1 {
            selectedText.text = "Quantity: " + pickerItem[0]
        }
         validateEditCart()
        self.view.endEditing(true)
    }
    
}
