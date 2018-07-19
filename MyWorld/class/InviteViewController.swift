//
//  InviteViewController.swift
//  MyWorld
//
//  Created by MyWorld on 06/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
   
    
    @IBOutlet weak var lblQrcodeName: UILabel!
    
    
    @IBOutlet weak var imgQrCode: UIImageView!
    
    var filter:CIFilter!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnMenuButton.target=revealViewController()
        btnMenuButton.action=#selector(SWRevealViewController.revealToggle(_:))
        
        
        let text =  UserDefaults.standard.value(forKey: "EmailId") as! String
        let data = text.data(using: .ascii,allowLossyConversion: false)
        filter = CIFilter(name: "CIQRCodeGenerator")
        filter.setValue(data,forKey: "inputMessage")
        let image = UIImage(ciImage: filter.outputImage!)
        imgQrCode.image = image
        let name = UserDefaults.standard.value(forKey: "EmailId") as! String
        lblQrcodeName.text!  = "Qr code "+name
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1000000015, green: 0.3860000074, blue: 0.7459999919, alpha: 1)
        
    }
    @IBAction func btnMyRewardsButton(_ sender: Any) {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "MyRewardsViewController") as! MyRewardsViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

    }
    
    @IBAction func btnShareInvite(_ sender: Any) {
    // MARK: - Helper Methods
      print("Rounak Share Option\n\n")
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
  
}
