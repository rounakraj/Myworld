//
//  BrowseCategoryViewController.swift
//  MyWorld
//
//  Created by MyWorld on 06/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD

class BrowseCategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var browseCollectionView: UICollectionView!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
   private var categorylist = [BrowseCategory]()
    override func viewDidLoad() {
        super.viewDidLoad()

     
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: 160)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        browseCollectionView!.collectionViewLayout = layout
        validateBrowseCategory()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated:true)

    }
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    func validateBrowseCategory() {
        SVProgressHUD.show(withStatus: "Loading")
        let urlToRequest = WEBSERVICE_URL+"getCategory.php"
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
            if let data = data {
                DispatchQueue.main.async { // Correct
                    
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("***** \(String(describing: dataString))") //JSONSerialization
                    SVProgressHUD.dismiss()

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
                    let  downloadBrowseCategory = try decoder.decode(BrowseCategorys.self, from: data!)
                    self.categorylist = downloadBrowseCategory.categorylist
                    DispatchQueue.main.async { // Correct
                        
                        self.browseCollectionView.reloadData()
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
    
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorylist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowesCollectionViewCell", for: indexPath) as! BrowesCollectionViewCell
        cell.lblName.text! = categorylist[indexPath.row].catName
        
        
        if let imageURL = URL(string: categorylist[indexPath.row].catImage){
            cell.imgImage.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
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
        
       let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
        desCV.getCatId = categorylist[indexPath.row].catId
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }

}
