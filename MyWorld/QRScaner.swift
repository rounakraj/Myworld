//
//  ViewController.swift
//  QRCodeReaderDemo
//
//  Created by TheAppGuruz-iOS-103 on 19/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftQRScanner

class QRScaner: UIViewController,QRScannerCodeDelegate
{
   
    func qrCodeScanningDidCompleteWithResult(result: String) {
        print("result:\(result)")
        
    }
    
    func qrCodeScanningFailedWithError(error: String) {
        print("error:\(error)")
        
    }
    
   
    @IBOutlet weak var lblQRCodeResult: UILabel!
    //@IBOutlet weak var lblQRCodeLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let scanner = QRCodeScannerController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    
}

