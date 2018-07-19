//
//  MYPickerView.swift
//  MyWorld
//
//  Created by Shankar Kumar on 11/02/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
protocol MYPickerViewDelegate {
    func cancelClicked()
    func doneClicked()
    
}
class MYPickerView: UIView {
    @IBOutlet weak var pickerView: UIPickerView!
    var delegate:MYPickerViewDelegate?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    static let shared:MYPickerView = {
        let shared = Bundle.main.loadNibNamed("MYPickerView", owner: self, options: nil)?.first as? MYPickerView
        shared?.frame = CGRect(x:0, y: (AppDelegate.getAppDelegate().window?.frame.size.height)!-220.0, width: (AppDelegate.getAppDelegate().window?.frame.size.width)!, height: 220.0)
        return shared!
        
    }()
    @IBAction func cancelClicked(_ sender: Any) {
        delegate?.cancelClicked()
    }
    @IBAction func doneClicked(_ sender: Any) {
        delegate?.doneClicked()
    }
}
