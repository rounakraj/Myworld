//
//  SearchDetailItemVC.swift
//  MyWorld
//
//  Created by MyWorld on 09/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class SearchDetailItemVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate{
    
    @IBAction func backPress(_ sender: Any) {
        
         navigationController?.popViewController(animated:true)
    }
    
    private var productServer = [SearchDetails]()
    private var productUser = [SearchDetails]()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
 @IBOutlet weak var searchView: UISearchBar!
    
    @IBOutlet weak var searchDetailCollectionView: UICollectionView!
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchKeydata = searchBar.text
        validateSearchProduc(searchKeydata: searchKeydata!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/1.5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        searchDetailCollectionView!.collectionViewLayout = layout
    }
    
    func validateSearchProduc(searchKeydata:String) {
        let searchKeydata = searchKeydata
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"searchProduct.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="search="+searchKeydata
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
                    let  downloadproductServer = try decoder.decode(SearchDetail.self, from: data!)
                    self.productServer = downloadproductServer.productServer
                    
                    let  downloadproductUser = try decoder.decode(SerchDetai.self, from: data!)
                    self.productUser = downloadproductUser.productUser
                    
                    self.productServer.append(contentsOf: self.productUser)
                    
                    DispatchQueue.main.async { // Correct
                        
                        self.searchDetailCollectionView.reloadData()
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productServer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDetailsCollectionViewCell", for: indexPath) as! SearchDetailsCollectionViewCell
        
        cell.lblSearchDetailName.text! = productServer[indexPath.row].productName
        cell.lblProductNameSearchDetail.text! = productServer[indexPath.row].productPrice
        cell.lblUplodByName.text! = productServer[indexPath.row].userName
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        if let imageURL = URL(string: productServer[indexPath.row].productImage1){
            cell.imgeSearchDetail.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
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
        desCV.getProductId = productServer[indexPath.row].productId
        desCV.getuserName = productServer[indexPath.row].userName
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
    

}
