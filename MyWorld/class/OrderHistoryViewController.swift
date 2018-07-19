//
//  OrderHistoryViewController.swift
//  MyWorld
//
//  Created by MyWorld on 06/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var tableviewOrderHistory: UITableView!
    
    var ishide = false
    @IBAction func btnBackPress(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    private var orderList = [HistoryOrderList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        validateShowOrder()
      
    }

    func validateShowOrder() {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"showOrder.php"
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
                print("*****ResponsePublicUser \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadorderList = try decoder.decode(HistoryOrderLists.self, from: data!)
                    self.orderList = downloadorderList.orderList
                    DispatchQueue.main.async { // Correct
                        
                        self.tableviewOrderHistory.reloadData()
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
        
        return orderList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if ishide{
             return 140;
        }else{
             return 260;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTableViewCell")as? OrderHistoryTableViewCell else{ return UITableViewCell ()}

        cell.lblHsProductName.text = orderList[indexPath.row].productName
        cell.lblHsPrice.text = orderList[indexPath.row].productPrice
        cell.lblHistorySpecialPrice.text = orderList[indexPath.row].ProductsplPrice
        cell.lblQty.text = "Qty: "+orderList[indexPath.row].ProductsplPrice
        cell.lblHistoryDate.text = orderList[indexPath.row].orderDate
        cell.lblHistoryPaymentType.text = orderList[indexPath.row].paymentType
        
         cell.btnDropeDown.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        if let imageURL = URL(string: orderList[indexPath.row].productImage1){
            cell.imgHistory.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
        
        
        
        let orderStatus = orderList[indexPath.row].orderStatus
        if(orderStatus == "0")
        {
            cell.circle1.image = UIImage(named: "green")
            cell.date1.text = orderList[indexPath.row].orderDate
            
        }else if(orderStatus == "1")
        {

            cell.circle1.image = UIImage(named: "blueimage")
            cell.circle2.image = UIImage(named: "green")
            cell.date2.text = orderList[indexPath.row].processingDate
            cell.date1.text = orderList[indexPath.row].deliveredDate
    
            let blueColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
            cell.line1.backgroundColor = blueColor
           

        }else if(orderStatus == "2")
        {
            cell.circle1.image = UIImage(named: "blueimage")
            cell.circle2.image = UIImage(named: "blueimage")
            cell.circle3.image = UIImage(named: "green")
            cell.date2.text = orderList[indexPath.row].processingDate
            cell.date1.text = orderList[indexPath.row].deliveredDate
            cell.date3.text = orderList[indexPath.row].dispatchDate
            
            let blueColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
            cell.line1.backgroundColor = blueColor
            cell.line2.backgroundColor = blueColor
            
            
        }else if(orderStatus == "3")
        {
            cell.circle1.image = UIImage(named: "blueimage")
            cell.circle2.image = UIImage(named: "blueimage")
            cell.circle3.image = UIImage(named: "blueimage")
            cell.circle4.image = UIImage(named: "green")
            cell.date2.text = orderList[indexPath.row].processingDate
            cell.date1.text = orderList[indexPath.row].deliveredDate
            cell.date3.text = orderList[indexPath.row].dispatchDate
            cell.date4.text = orderList[indexPath.row].shippingDate
            let blueColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
            cell.line1.backgroundColor = blueColor
            cell.line2.backgroundColor = blueColor
            cell.line3.backgroundColor = blueColor
            
        }else if(orderStatus  == "4")
        {
            cell.circle1.image = UIImage(named: "blueimage")
            cell.circle2.image = UIImage(named: "blueimage")
            cell.circle3.image = UIImage(named: "blueimage")
            cell.circle4.image = UIImage(named: "blueimage")
            cell.circle5.image = UIImage(named: "green")
            cell.date2.text = orderList[indexPath.row].processingDate
            cell.date1.text = orderList[indexPath.row].deliveredDate
            cell.date3.text = orderList[indexPath.row].dispatchDate
            cell.date4.text = orderList[indexPath.row].shippingDate
            cell.date5.text = orderList[indexPath.row].deliveredDate
            let blueColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
            cell.line1.backgroundColor = blueColor
            cell.line2.backgroundColor = blueColor
            cell.line3.backgroundColor = blueColor
            cell.line4.backgroundColor = blueColor
        }
        
        
        
        return cell
    }
    
    
    
    
    @objc func checkMarkButtonClicked(sender: UIButton) {
        if ishide {
            sender.setImage(#imageLiteral(resourceName: "ic_blackuparrow"), for: .normal)
            ishide = false
        }else{
            ishide = true
            sender.setImage(#imageLiteral(resourceName: "ic_blackdownarrow"), for: .normal)
        }
        self.tableviewOrderHistory.reloadData()
        
    }
    

   
}
