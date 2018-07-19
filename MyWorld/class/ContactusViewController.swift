//
//  ContactusViewController.swift
//  MyWorld
//
//  Created by MyWorld on 06/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import MessageUI
import AFNetworking

class ContactusViewController: UIViewController,MFMailComposeViewControllerDelegate {
   
    
    @IBAction func backPress(_ sender: Any) {
        
        navigationController?.popViewController(animated:true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     // validateSell()
    }
    
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }

    @IBAction func callAction(_ sender: Any) {
        if let url = URL(string: "tel://+919998889947"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func mailAction(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    @IBAction func faceBookAction(_ sender: Any) {
       YMSocialShare.shareOn(serviceType:.otherApps,text:"Checkout My World application. Download from Android PlayStore or iOS Appstore",image:#imageLiteral(resourceName: "logo"))
    }
    
    @IBAction func googleAction(_ sender: Any) {
        YMSocialShare.shareOn(serviceType:.otherApps,text:"Checkout My World application. Download from Android PlayStore or iOS Appstore",image:#imageLiteral(resourceName: "logo"))
    }
    
    @IBAction func twiterAction(_ sender: Any) {
        YMSocialShare.shareOn(serviceType:.otherApps,text:"Checkout My World application. Download from Android PlayStore or iOS Appstore",image:#imageLiteral(resourceName: "logo"))
    }
    
    func validateSell() {

        let manager = AFHTTPSessionManager()
        let serializerRequest = AFJSONRequestSerializer()
        serializerRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer = serializerRequest
        
        let serializerResponse = AFJSONResponseSerializer()
        serializerResponse.readingOptions = JSONSerialization.ReadingOptions.allowFragments
        serializerResponse.acceptableContentTypes = ((((NSSet(object: "text/html") as! Set<String>) as Set<String>) as Set<String>) as Set<String>) as Set<String>;
        manager.responseSerializer = serializerResponse
        manager.post("http://18.221.196.77/myworldapi/contactUs.php", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                print("responseObject \(responseObject)")
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["info@myworld.com"])
        mailComposerVC.setSubject("Contact Us")
        mailComposerVC.setMessageBody("Hi,", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
