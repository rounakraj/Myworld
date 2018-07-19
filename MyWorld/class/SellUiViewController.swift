//
//  SellUiViewController.swift
//  MyWorld
//
//  Created by MyWorld on 12/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD

class SellUiViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var lblBudge: UILabel!
    var cartList = [CartList]()

    
    
    @IBAction func backPress(_ sender: Any) {
        navigationController?.popViewController(animated:true)
}
    
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
    
    
    @IBAction func btnPostAddButton(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "PostAddViewController") as! PostAddViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    
    
    @IBOutlet weak var sellCollectionView: UICollectionView!
    private var productUser2 = [SellProductList]()
     private var productUser1 = [SellProductList]()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblBudge.isHidden=true

        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        sellCollectionView!.collectionViewLayout = layout
        
        validateSell()
        
        lblBudge.clipsToBounds = true
        lblBudge.layer.cornerRadius = lblBudge.frame.size.height/2
        lblBudge.layer.borderWidth = 0.8
        lblBudge.layer.borderColor = UIColor.clear.cgColor
        validateShowCart(UserId: UserDefaults.standard.value(forKey: "userId") as! String)

    }


    func validateSell() {
        SVProgressHUD.show(withStatus: "Loading")
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
                SVProgressHUD.dismiss()
                return
            }
            do {
                SVProgressHUD.dismiss()
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
                        
                        self.sellCollectionView.reloadData()
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
        return productUser2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellCollectionViewCell", for: indexPath) as! SellCollectionViewCell

        cell.lblSellBrandName.text! = productUser2[indexPath.row].productName
        cell.lblSellUploadbyName.text! = productUser2[indexPath.row].userName
        cell.lblSellPrice.text! = productUser2[indexPath.row].productPrice
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1).cgColor
        cell.contentView.layer.masksToBounds = true
        
        if let imageURL = URL(string: productUser2[indexPath.row].productImage1){
            cell.imageSellImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
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
        desCV.getProductId = productUser2[indexPath.row].productId
        desCV.getuserName = productUser2[indexPath.row].userName
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
    
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
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
