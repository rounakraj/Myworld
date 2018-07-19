//
//  AddressDeliverViewController.swift
//  MyWorld
//
//  Created by MyWorld on 04/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddressDeliverViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableviewAddress: UITableView!
    
    @IBAction func backPress(_ sender: Any) {
        
        navigationController?.popViewController(animated:true)
    }
    private var addressList = [AdressList]()
    var isBoxclickde:Bool!
    var checkedimage = UIImage(named: "checkedbox")
    var Uncheckedimage = UIImage(named: "checkbox")
    
    var addressId = ""

    @IBAction func btnAdd(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "AddAdressViewController") as! AddAdressViewController
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
    @IBAction func btnNext(_ sender: Any) {
        if addressId.count == 0 {
            SVProgressHUD.showInfo(withStatus: "Please add address")
            return
        }
        PaymentDetailData.shared.addressID = addressId

        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "AddPymentViewController") as! AddPymentViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CartIt>>>>>",PaymentDetailData.shared.cartID ?? "")
        print("price>>>>>",PaymentDetailData.shared.totalPrice ?? "")
        
        tableviewAddress.dataSource = self
        tableviewAddress.delegate = self
        validateAddress()
        

    }

   
    
    func validateAddress() {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
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
                DispatchQueue.main.async { // Correct
                    
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("***** \(String(describing: dataString))") //JSONSerialization
                    SVProgressHUD.dismiss()
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
                        
                        self.tableviewAddress.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableVC")as? AddressTableVC else{ return UITableViewCell ()}
        
        let firstName = (UserDefaults.standard.value(forKey: "firstName") as? String)
        let lastName = UserDefaults.standard.value(forKey: "lastName") as? String
        
        cell.lblNameAddress.text = firstName! + ", " + lastName!
        cell.lblAddress.text = "H.NO " + addressList[indexPath.row].houseNo + " " + addressList[indexPath.row].street + " " + addressList[indexPath.row].city + " " + addressList[indexPath.row].state + " " + addressList[indexPath.row].country + "Mobile: " + addressList[indexPath.row].mobileNo
        
        cell.btnPencil.tag = indexPath.row
        cell.btnPencil.addTarget(self, action: #selector(editAddress), for: UIControlEvents.touchUpInside)

    
        let Type = addressList[indexPath.row].defaultType
        if Type == "1"{
            cell.btnCheckBox.setImage(checkedimage, for: UIControlState.normal)
            addressId = addressList[indexPath.row].addressId

        }else{
            
            cell.btnCheckBox.setImage(Uncheckedimage, for: UIControlState.normal)
        }
        cell.btnCheckBox.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200;
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
            addressId = addressList[sender.tag].addressId
            validateSetaddressDefault(position: sender.tag)
        }
    }
    
    

    func validateSetaddressDefault(position: Int) {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        SVProgressHUD.show(withStatus: "Loading")
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
                print("*****ResponseAdress\(String(describing: Data))") //JSONSerialization
                SVProgressHUD.dismiss()

                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadaddressList = try decoder.decode(AdressLists.self, from: data!)
                    self.addressList = downloadaddressList.addressList
                    DispatchQueue.main.async { // Correct
                        
                        self.tableviewAddress.reloadData()
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
    
   

}
