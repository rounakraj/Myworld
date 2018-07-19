//
//  BuyItemListViewController.swift
//  MyWorld
//
//  Created by MyWorld on 13/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class BuyItemListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var buyItemListCollectionView: UICollectionView!
    var itemText: String?
    
    var newproduct = [NewProductList]()
    var popularList = [PopularList]()
    var dealsListServer = [DealsList]()
    var dealsListsUser = [DealsList]()
    var trendingList = [TrendingList]()
    var arraySize: Int = 0
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()


       
        if(itemText=="0")
        {
            validateNew()
            
        }else if(itemText=="1"){
            validatePopularProduct()
            
            
        }else if(itemText=="2"){
            validateDeals()
            
        }else if(itemText=="3"){
            validateTrendingProduct()

            
        }
    }
    
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return arraySize
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyItemListCollectionViewCell", for: indexPath) as! BuyItemListCollectionViewCell
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1).cgColor
        cell.contentView.layer.masksToBounds = true
        
        if(itemText=="0")
        {
            cell.lblBuyUplodByName.text! = newproduct[indexPath.row].userName
            cell.lblBuyPrice.text! = "INR " + newproduct[indexPath.row].productPrice + " Offer " + newproduct[indexPath.row].Percent + "% Off"
            cell.lblBuyProductName.text! = newproduct[indexPath.row].productName
            
            if let imageURL = URL(string: newproduct[indexPath.row].productImage1){
                
                cell.imageBuyItemImageview.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
            
        }else if(itemText=="1"){
            
            cell.lblBuyUplodByName.text! = popularList[indexPath.row].userName
            cell.lblBuyPrice.text! = "INR " + popularList[indexPath.row].productPrice + " Offer " + popularList[indexPath.row].Percent + "% Off"
            cell.lblBuyProductName.text! = popularList[indexPath.row].productName
            
            if let imageURL = URL(string: popularList[indexPath.row].productImage1){
                cell.imageBuyItemImageview.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
            
        }else if(itemText=="2"){
            
            cell.lblBuyUplodByName.text! = dealsListServer[indexPath.row].userName
            cell.lblBuyPrice.text! = "INR " + dealsListServer[indexPath.row].productPrice + " Offer " + dealsListServer[indexPath.row].Percent + "% Off"
            cell.lblBuyProductName.text! = dealsListServer[indexPath.row].productName
            
            if let imageURL = URL(string: dealsListServer[indexPath.row].productImage1){
                cell.imageBuyItemImageview.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
            
        }else if(itemText=="3"){
            
            cell.lblBuyUplodByName.text! = trendingList[indexPath.row].userName
            cell.lblBuyPrice.text! = "INR " + trendingList[indexPath.row].productPrice + " Offer " + trendingList[indexPath.row].Percent + "% Off"
            cell.lblBuyProductName.text! = trendingList[indexPath.row].productName
            
            if let imageURL = URL(string: trendingList[indexPath.row].productImage1){
                cell.imageBuyItemImageview.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if(itemText=="0")
        {
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProducatViewController") as! ProducatViewController
            desCV.getProductId = newproduct[indexPath.row].productId
            desCV.getuserName = newproduct[indexPath.row].userName
            self.navigationController?.pushViewController(desCV, animated: true)
            
        }else if(itemText=="1"){
            
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProducatViewController") as! ProducatViewController
            desCV.getProductId = popularList[indexPath.row].productId
            desCV.getuserName = popularList[indexPath.row].userName
            self.navigationController?.pushViewController(desCV, animated: true)
            
        }else if(itemText=="2"){
            
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProducatViewController") as! ProducatViewController
            desCV.getProductId = dealsListServer[indexPath.row].productId
            desCV.getuserName = dealsListServer[indexPath.row].userName
            self.navigationController?.pushViewController(desCV, animated: true)
            
        }else if(itemText=="3"){
        
            
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProducatViewController") as! ProducatViewController
            desCV.getProductId = trendingList[indexPath.row].productId
            desCV.getuserName = trendingList[indexPath.row].userName
            self.navigationController?.pushViewController(desCV, animated: true)
            
        }
       
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        
        return CGSize(width: width, height: 210)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 1.0
    }
    
    func validateNew() {
        SVProgressHUD.show(withStatus: "Loading")
        let urlToRequest = WEBSERVICE_URL+"getnewProduct.php"
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
            do {
                SVProgressHUD.dismiss()
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseNew \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    
                    let decoder = JSONDecoder()
                    let  downloadNewList = try decoder.decode(NewList.self, from: data!)
                    self.newproduct = downloadNewList.productAll
                    self.arraySize = self.newproduct.count

                    DispatchQueue.main.async { // Correct
                        //Todo view update
                        self.buyItemListCollectionView.reloadData()

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
    
    
    
    func validatePopularProduct() {
        SVProgressHUD.show(withStatus: "Loading")
        
        let urlToRequest = WEBSERVICE_URL+"getpopularProduct.php"
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
            
            do {
                SVProgressHUD.dismiss()
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponsePopularProduct \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadproductAll = try decoder.decode(PopularLists.self, from: data!)
                    self.popularList = downloadproductAll.productAll
                    self.arraySize = self.popularList.count

                    DispatchQueue.main.async { // Correct
                        
                        self.buyItemListCollectionView.reloadData()
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
    
    
    func validateDeals() {
        SVProgressHUD.show(withStatus: "Loading")
        
        let urlToRequest = WEBSERVICE_URL+"getProduct.php"
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
            do {
                
                SVProgressHUD.dismiss()
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseDeals \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloaddealsListServer = try decoder.decode(DealsListServer.self, from: data!)
                    self.dealsListServer = downloaddealsListServer.productServer
                    
                    let  downloadproductUser = try decoder.decode(DealsListsUser.self, from: data!)
                    self.dealsListsUser = downloadproductUser.productUser
                    
                    self.dealsListServer.append(contentsOf: self.dealsListsUser)
                    self.arraySize = self.dealsListServer.count

                    DispatchQueue.main.async { // Correct
                        
                        self.buyItemListCollectionView.reloadData()
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
    
    
    func validateTrendingProduct() {
        SVProgressHUD.show(withStatus: "Loading")
        
        let urlToRequest = WEBSERVICE_URL+"gettrendingProduct.php"
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
            do {
                SVProgressHUD.dismiss()
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseTrendingProduct \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadproductAll = try decoder.decode(TrendingLists.self, from: data!)
                    self.trendingList = downloadproductAll.productAll
                    self.arraySize = self.trendingList.count

                    DispatchQueue.main.async { // Correct
                        self.buyItemListCollectionView.reloadData()
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
    
    
    

}
