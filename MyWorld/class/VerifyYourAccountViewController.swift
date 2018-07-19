//
//  VerifyYourAccountViewController.swift
//  MyWorld
//
//  Created by MyWorld on 11/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class VerifyYourAccountViewController: UIViewController {
    
    @IBOutlet weak var txtEnterOtp: UITextField!
    
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var lblTimer: UILabel!
    var timer = Timer()
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        activityindicator.hidesWhenStopped = true;
        activityindicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityindicator.center = view.center;
        view.addSubview(activityindicator)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

    }
    @objc func updateCounter() {
        counter = counter + 1
        lblTimer.text = String(counter)
    }
    
    @IBAction func resendButton(sender: AnyObject) {
        timer.invalidate()
        counter = 0
        lblTimer.text = String(counter)
    }
    func removeTimer() {
        timer.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func btnBack(_ sender: Any) {

    }
    
    
    @IBAction func btnActionSubmit(_ sender: Any) {
        
        let serverOtp=UserDefaults.standard.value(forKey: "otp")
        let userId=UserDefaults.standard.value(forKey: "userId")
        NSLog(serverOtp as! String)
        NSLog(userId as! String)
        
        validateVerifyEmail(UserId: UserDefaults.standard.value(forKey: "userId") as! String,Otp: txtEnterOtp.text!)
        /*if String(describing: Otp)==String (describing: serverOtp){
            
        }else{
            // Create the alert controller
            let alertController = UIAlertController(title: "My World", message: "Please enter correct otp.", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
            }
            // Add the actions
            alertController.addAction(okAction)
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        */
    }
    
    func validateVerifyEmail(UserId:String,Otp: String) {
        
        let userId=UserId
        let Otp = Otp
        self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"verifyAccount.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+userId+"&"+"otp="+Otp
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
                    
                    DispatchQueue.main.async {
                        
                        // Create the alert controller
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        self.removeTimer()
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                            self.present(newViewController, animated: true, completion: nil)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)

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
