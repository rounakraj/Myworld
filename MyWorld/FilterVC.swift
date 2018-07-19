//
//  FilterVC.swift
//  MyWorld
//
//  Created by Shankar Kumar on 06/02/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import GooglePlacePicker
import GoogleMaps
import IQKeyboardManagerSwift

protocol FilterBackDelegate {
    func filterbackData()
    
}
protocol FilterDelegate {
    func filterData(selectedBrand:String,selectedLoc:NSString,minRange:Double, maxRange:Double)
    func filterDataClear()
}
class FilterVC: UIViewController,GMSAutocompleteViewControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtBrand: UITextField!
    var pickOption = NSArray()
    var subCatID = ""
    var selectedBrand = ""
    
    var delegate:FilterDelegate?
    var delegateback:FilterBackDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyAZ3BNg4DqwhMXsLrZ8xjYlKi7djrUcIts")
        GMSPlacesClient.provideAPIKey("AIzaSyAZ3BNg4DqwhMXsLrZ8xjYlKi7djrUcIts")
        getBrandData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.sharedManager().enable = false;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.sharedManager().enable = true;

    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.filterDataClear()
    }
    @IBAction func applyAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

        delegate?.filterData(selectedBrand: selectedBrand, selectedLoc: txtLocation.text! as NSString, minRange: rangeSlider.lowerValue, maxRange: rangeSlider.upperValue)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pickUpAddress(_ sender: Any) {
        self.view.endEditing(true)

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        txtLocation.text = place.formattedAddress
            //dropLat = String(place.coordinate.latitude)
            //dropLong = String(place.coordinate.longitude)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    @IBAction func selectBrand(_ sender: UITextField) {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        sender.inputView = pickerView
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self,
                                              action: #selector(self.doneClicked(sender:)))
        
        keyboardDoneButtonView.items = [doneButton]
        sender.inputAccessoryView = keyboardDoneButtonView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return (pickOption[row] as AnyObject).value(forKey: "brandName") as! String
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtBrand.text = (pickOption[row] as AnyObject).value(forKey: "brandName") as! String
        selectedBrand = (pickOption[row] as AnyObject).value(forKey: "brandId") as! String

    }
    
    
    @objc func doneClicked(sender: AnyObject) {
        
        if (txtBrand.text?.characters.count) == 0 && pickOption.count > 0 {
            txtBrand.text = (pickOption[0] as AnyObject).value(forKey: "brandName") as! String
            selectedBrand = (pickOption[0] as AnyObject).value(forKey: "brandId") as! String

        }
        self.view.endEditing(true)
    }
    
    
    
    func getBrandData() -> Void {
        
        let postData = NSMutableData(data: "subcatId=\(subCatID)".data(using: String.Encoding.utf8)!)
        
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "getBrand.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                
            }else{
                
                print(data);
                
                if data .value(forKey: "responseCode") as! String == "200"{
                    DispatchQueue.main.async(execute: {
                        
                        let value: AnyObject? = data.value(forKey: "brand") as AnyObject
                        
                        if value is NSString {
                            print("It's a string")
                            
                        } else if value is NSArray {
                            print("It's an NSArray")
                            
                            self.pickOption = value as! NSArray
                            
                            
                        }
                    })
                }else{
                    
                }
                
            }
            
        })
    }

}
