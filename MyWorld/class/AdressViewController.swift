//
//  AdressViewController.swift
//  MyWorld
//
//  Created by MyWorld on 15/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD

class AdressViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var adressUITableView: UITableView!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    private var addressList = [AdressList]()
    var checkedimage = UIImage(named: "checkedbox")
    var Uncheckedimage = UIImage(named: "checkbox")
    var isBoxclickde:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnMenuButton.target=revealViewController()
        btnMenuButton.action=#selector(SWRevealViewController.revealToggle(_:))
    
        validateAddress(UserId: UserDefaults.standard.value(forKey: "userId") as! String)

    }
    
    
    @IBAction func btnAddAdressButton(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "AddAdressViewController") as! AddAdressViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func backPressButton(_ sender: Any) {
    
        navigationController?.popViewController(animated:true)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    
    }
    
    func validateAddress(UserId:String) {
        let userId=UserId
        SVProgressHUD.show(withStatus: "Loading")
        let urlToRequest = WEBSERVICE_URL+"getAddress.php"
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
                    
                }
            }
            
            do {
                SVProgressHUD.dismiss()

                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseAdress\(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadaddressList = try decoder.decode(AdressLists.self, from: data!)
                    self.addressList = downloadaddressList.addressList
                    DispatchQueue.main.async { // Correct
                        
                        self.adressUITableView.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdresshTableViewCell")as? AdresshTableViewCell else{ return UITableViewCell ()}
        
        let firstName = (UserDefaults.standard.value(forKey: "firstName") as? String)
        let lastName = UserDefaults.standard.value(forKey: "lastName") as? String
        cell.btnDeleteButton.tag = indexPath.row
        cell.btnDeleteButton.addTarget(self, action: #selector(editAddress), for: UIControlEvents.touchUpInside)
        cell.lblAdressName.text = firstName! + ", " + lastName!
        cell.lblAdress.text = "H.NO " + addressList[indexPath.row].houseNo + " " + addressList[indexPath.row].street + " " + addressList[indexPath.row].city + " " + addressList[indexPath.row].state + " " + addressList[indexPath.row].country + "Mobile: " + addressList[indexPath.row].mobileNo
        
         cell.btnCheckBox.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        let Type = addressList[indexPath.row].defaultType
        if Type == "1"{
            cell.btnCheckBox.setImage(checkedimage, for: UIControlState.normal)

        }else{
            
            cell.btnCheckBox.setImage(Uncheckedimage, for: UIControlState.normal)
        }
       tableView.separatorStyle = .singleLine
        return cell
    }
   

    @objc func editAddress(sender:UIButton){
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "AddAdressViewController") as! AddAdressViewController
                desCV.mobileNo = addressList[sender.tag].mobileNo
                desCV.HouseNo =  addressList[sender.tag].houseNo
                desCV.Landmark =  addressList[sender.tag].landmark
                desCV.City =  addressList[sender.tag].city
                desCV.State =  addressList[sender.tag].state
                desCV.Country =  addressList[sender.tag].country
                desCV.Pincode =  addressList[sender.tag].pincode
                desCV.AddressId =  addressList[sender.tag].addressId
                desCV.DefaultType =  addressList[sender.tag].defaultType
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @objc func checkMarkButtonClicked(sender: UIButton) {
        
        if sender.isSelected{
            //uncheck button
            sender.isSelected = false
            
        }else{
            
            //checked markdIt
            sender.isSelected = true
            validateSetaddressDefault(position: sender.tag)
        }
    }
    

    func validateSetaddressDefault(position: Int) {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        //self.activityIndicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"setaddressDefault.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+userId+"&"+"addressId="+addressList[position].addressId
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
                    //self.activityIndicator.stopAnimating();
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseAdress\(String(describing: Data))") //JSONSerialization
                
                
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

}
