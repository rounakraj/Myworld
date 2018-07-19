//
//  TermsConditonViewController.swift
//  MyWorld
//
//  Created by MyWorld on 07/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class TermsConditonViewController: UIViewController,WKNavigationDelegate{
    
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    let path = Bundle.main.path(forResource: "termscondition", ofType: nil)!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview.navigationDelegate = self
        self.activityindicator.startAnimating()
        self.activityindicator.hidesWhenStopped = false
        let content = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)

        webview.loadHTMLString(content, baseURL: nil)
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       self.activityindicator.stopAnimating()
       self.activityindicator.hidesWhenStopped = true
    }
    

}
