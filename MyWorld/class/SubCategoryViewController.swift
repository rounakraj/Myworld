//
//  SubCategoryViewController.swift
//  MyWorld
//
//  Created by MyWorld on 12/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class SubCategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBAction func backPress(_ sender: Any) {
        navigationController?.popViewController(animated:true)

    }
    
    @IBOutlet weak var tableviewcell: UITableView!
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    var getCatId = String()
    private var subcategory = [SubCategoryResourse]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityindicator.hidesWhenStopped = true;
        activityindicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityindicator.center = view.center;
        view.addSubview(activityindicator)
        let catId: String = getCatId
        validateSubCategory(catId: catId)
        
    }

    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    func validateSubCategory(catId:String) {
        let catId=catId
        self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"getsubCategory.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="catId="+catId
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
                    self.activityindicator.stopAnimating();
                    
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
                    let  downloadsubcategory = try decoder.decode(SubCategoryResourseList.self, from: data!)
                    self.subcategory = downloadsubcategory.subcategory
                    DispatchQueue.main.async { // Correct
                        
                        self.tableviewcell.reloadData()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subcategory.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell")as? SubCategoryTableViewCell else{ return UITableViewCell ()}
        
            cell.lblSubCategoryName.text = subcategory[indexPath.row].subcatName
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          let cell:SubCategoryTableViewCell = tableView.cellForRow(at: indexPath) as! SubCategoryTableViewCell
        print(cell.lblSubCategoryName.text!)
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "BrowseSubCategoryViewController") as! BrowseSubCategoryViewController
        desCV.getsubcatId = subcategory[indexPath.row].subcatId
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
    


}
