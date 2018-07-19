//
//  AddPymentViewController.swift
//  MyWorld
//
//  Created by MyWorld on 04/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class AddPymentViewController: UIViewController {

    @IBOutlet weak var viewCash: UIView!
    @IBOutlet weak var viewonline: UIView!

    var isCash:Bool!

    var StringBuilder = String()
    var StringBuilder1 = String()
    var addressId = String ()
    var similarList = [SimilarList]()
    var orderList = [OrderList]()
    var payBy = String()
    
    
    public var quoteId:String = ""
    public var shippingId:String = ""
    
    @IBOutlet weak var amountLbl: UILabel!


    @IBAction func backPress(_ sender: Any) {
        
         navigationController?.popViewController(animated:true)
    }
    
    @IBOutlet weak var checkCheckde: UIButton!
    @IBOutlet weak var checkCheckde2: UIButton!
    
    var checkedimage = UIImage(named: "checkedbox")
    var Uncheckedimage = UIImage(named: "checkbox")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("CartIt>>>>>",PaymentDetailData.shared.cartID ?? "")
        print("price>>>>>",PaymentDetailData.shared.totalPrice ?? "")
        print("addressID>>>>>",PaymentDetailData.shared.addressID ?? "")

        viewCash.layer.borderWidth = 0.8
        viewCash.layer.borderColor = UIColor.gray.cgColor
        
        viewonline.layer.borderWidth = 0.8
        viewonline.layer.borderColor = UIColor.gray.cgColor
        
    }

 
    
    @IBAction func btnCheckBox1(_ sender: Any) {
        
        isCash = true
        checkCheckde.setImage(checkedimage, for: UIControlState.normal)
        checkCheckde2.setImage(Uncheckedimage, for: UIControlState.normal)

    }
    
    @IBAction func btnCheckBox2(_ sender: Any) {
        
        isCash = false
        checkCheckde.setImage(Uncheckedimage, for: UIControlState.normal)
        checkCheckde2.setImage(checkedimage, for: UIControlState.normal)
    }
    
    
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        if isCash {
            validateAddOrder()

        }else{
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "CardInformationVc") as! CardInformationVc
            self.navigationController?.pushViewController(desCV, animated: true)
        }
       
    }
    
    
    func validateAddOrder() {
        //self.activityIndicator.startAnimating();
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        let urlToRequest = WEBSERVICE_URL+"addOrder.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let cartId = PaymentDetailData.shared.cartID ?? ""

        let paramString="userId="+UserId+"&"+"addressId="+addressId+"&"+"cartId="+cartId
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
                print("*****ResponseAddOrder\(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadadsimilarList = try decoder.decode(SimilarLists.self, from: data!)
                    self.similarList = downloadadsimilarList.similarList
                    
                    let  downloadadorderList = try decoder.decode(OrderLists.self, from: data!)
                    self.orderList = downloadadorderList.orderList
                    DispatchQueue.main.async { // Correct
                        self.navigationController?.popViewController(animated:true)

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
