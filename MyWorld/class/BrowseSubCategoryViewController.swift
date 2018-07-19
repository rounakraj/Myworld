//
//  BrowseSubCategoryViewController.swift
//  MyWorld
//
//  Created by MyWorld on 13/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD

class BrowseSubCategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
  
    var dataArray = NSArray()
    
    
    
    @IBOutlet weak var browseSubcatCollectionView: UICollectionView!
    
    @IBAction func pressBack(_ sender: Any) {
        
        navigationController?.popViewController(animated:true)
    }
    
    @IBAction func btnSortBy(_ sender: Any) {
        
        SortBy()
    }
    
    @IBAction func filterAction(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        desCV.subCatID = self.getsubcatId
        desCV.delegate = self
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    var getsubcatId = String()
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getproductbySubcat()
        activityindicator.stopAnimating()
        activityindicator.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.size.width/2, height:200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        browseSubcatCollectionView!.collectionViewLayout = layout
        
    }


    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseSubCategoryCollectionViewCell", for: indexPath) as! BrowseSubCategoryCollectionViewCell
        var dict = NSDictionary()
        dict = dataArray[indexPath.row] as! NSDictionary
        
        cell.lblBrowseSubProductName.text! = dict.value(forKey: "productName") as! String
        cell.lblBrowseSubProductUplodBy.text! = dict.value(forKey: "userName") as! String
        cell.lblBrowseSubProductPrice.text! = dict.value(forKey: "productPrice") as! String
        
        if let imageURL = URL(string: dict.value(forKey: "productImage1") as! String ){
            cell.imageBrowseSubImageview.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
        }
       
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1).cgColor
        cell.contentView.layer.masksToBounds = true
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 1
        
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var dict = NSDictionary()
        dict = dataArray[indexPath.row] as! NSDictionary
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProducatViewController") as! ProducatViewController
        desCV.getProductId = dict.value(forKey: "productId") as! String
        desCV.getuserName = dict.value(forKey: "userName") as! String
        self.navigationController?.pushViewController(desCV, animated: true)
        
        
    }
    
    
    
    func SortBy(){
        
        
        let actionSheet = UIAlertController(title: "Sort By", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Low To High", style: .default, handler: {(action: UIAlertAction)in
            
            self.validateBroseSortByCategory(sorttype: "Low To High",subcatId: self.getsubcatId)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "High To Low", style: .default, handler: {(action: UIAlertAction)in
            
           self.validateBroseSortByCategory(sorttype: "High To Low",subcatId: self.getsubcatId)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Popular", style: .default, handler: {(action: UIAlertAction)in
            
            self.validateBroseSortByCategory(sorttype: "Popular",subcatId: self.getsubcatId)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "New", style: .default, handler: {(action: UIAlertAction)in
            
             self.validateBroseSortByCategory(sorttype: "New",subcatId: self.getsubcatId)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    

}

extension BrowseSubCategoryViewController:FilterDelegate {
    func filterDataClear() {
        getproductbySubcat() 
    }
    
    func filterData(selectedBrand: String, selectedLoc: NSString, minRange: Double, maxRange: Double) {
        
        let postData = NSMutableData(data: "subcatId=\(self.getsubcatId)".data(using: String.Encoding.utf8)!)
        postData.append("&minPrice=\(minRange)".data(using: String.Encoding.utf8)!)
        postData.append("&maxPrice=\(maxRange)".data(using: String.Encoding.utf8)!)
        postData.append("&brandId=\(selectedBrand)".data(using: String.Encoding.utf8)!)
        postData.append("&location=\(selectedLoc)".data(using: String.Encoding.utf8)!)

        SVProgressHUD.show(withStatus: "Loading")
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "filterProduct.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                SVProgressHUD.dismiss()
            }else{
                
                print(data);
                SVProgressHUD.dismiss()
                if data .value(forKey: "responseCode") as! String == "200"{
                    let value: AnyObject? = data.value(forKey: "productServer") as AnyObject
                    
                    if value is NSString {
                        print("It's a string")
                        
                    } else if value is NSArray {
                        print("It's an NSArray")
                        
                        self.dataArray = value as! NSArray
                        
                        DispatchQueue.main.async { // Correct
                            
                            self.browseSubcatCollectionView.reloadData()
                        }
                        
                    }
                    
                }else{
                    SVProgressHUD.showInfo(withStatus: "responseMessage")
                    
                }
                
            }
            
        })
    }
    
    func validateBroseSortByCategory(sorttype: String,subcatId:String) {

        let postData = NSMutableData(data: "sort_type=\(sorttype)".data(using: String.Encoding.utf8)!)
        postData.append("&subcatId=\(subcatId)".data(using: String.Encoding.utf8)!)
        SVProgressHUD.show(withStatus: "Loading")
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "sortProduct.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                SVProgressHUD.dismiss()
            }else{
                
                print(data);
                SVProgressHUD.dismiss()
                if data .value(forKey: "responseCode") as! String == "200"{
                    let value: AnyObject? = data.value(forKey: "productAll") as AnyObject
                    
                    if value is NSString {
                        print("It's a string")
                        
                    } else if value is NSArray {
                        print("It's an NSArray")
                        
                        self.dataArray = value as! NSArray
                        
                        DispatchQueue.main.async { // Correct
                            
                            self.browseSubcatCollectionView.reloadData()
                        }
                        
                    }
                
                }else{
                    SVProgressHUD.showInfo(withStatus: "responseMessage")
                    
                }
                
            }
            
        })
    }
    
    
    
    
    func getproductbySubcat() {
        
        let postData = NSMutableData(data: "subcatId=\(self.getsubcatId)".data(using: String.Encoding.utf8)!)
        SVProgressHUD.show(withStatus: "Loading")
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "getproductbySubcat.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                SVProgressHUD.dismiss()
            }else{
                
                print(data);
                SVProgressHUD.dismiss()
                if data .value(forKey: "responseCode") as! String == "200"{
                    let value: AnyObject? = data.value(forKey: "productServer") as AnyObject
                    print(value);

                    if value is NSString {
                        print("It's a string")
                        
                    } else if value is NSArray {
                        print("It's an NSArray")
                        
                        self.dataArray = value as! NSArray
                        DispatchQueue.main.async { // Correct
                            
                            self.browseSubcatCollectionView.reloadData()
                        }
                    }
                    
                }else{
                    SVProgressHUD.showInfo(withStatus: "responseMessage")
                    
                }
                
            }
            
        })
    }
}

