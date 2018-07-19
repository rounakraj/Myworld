//
//  PostAddViewController.swift
//  MyWorld
//
//  Created by MyWorld on 08/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import GooglePlacePicker
import GoogleMaps

class PostAddViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MYPickerViewDelegate,GMSAutocompleteViewControllerDelegate{
    
    @IBOutlet weak var lblCatgory: UIButton!
    @IBOutlet weak var lblSubCategory: UIButton!
    @IBOutlet weak var lblBrandType: UIButton!
    @IBOutlet weak var lblModelType: UIButton!
    @IBOutlet weak var imageproduct1: UIImageView!
    @IBOutlet weak var imageproduct3: UIImageView!
    @IBOutlet weak var imageproduct2: UIImageView!
    @IBOutlet weak var lblInvoiceAvilable: UIButton!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtProductPrice: UITextField!
    @IBOutlet weak var productSlPricce: UITextField!
    @IBOutlet weak var txtProductConditon: UITextField!
    @IBOutlet weak var txtProductDescription: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    var imageData1 = NSData()
    var imageData2 = NSData()
    var imageData3 = NSData()
    private var categorylist = [Categorylist]()
    private var subcategory = [Subcategory]()
    private var brand = [ResourceBrandList]()
    private var model = [Brandmodel]()
    let pickerItem = ["Yes","No"]
    var counter = 0
    var categoryCheck = 0
    var CatId = ""
    var subcatId = ""
    var brandId = ""
    var brandIdModel = ""
    var Invoice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyAZ3BNg4DqwhMXsLrZ8xjYlKi7djrUcIts")
        GMSPlacesClient.provideAPIKey("AIzaSyAZ3BNg4DqwhMXsLrZ8xjYlKi7djrUcIts")
        self.txtLocation.addTarget(self, action: #selector(PostAddViewController.locationTapped), for: .editingDidBegin)
        ValidateGetCategory()
        let holdingView = AppDelegate.getAppDelegate().window?.rootViewController!.view!
        holdingView?.addSubview(MYPickerView.shared)
        MYPickerView.shared.delegate = self
        MYPickerView.shared.pickerView.delegate = self
        MYPickerView.shared.pickerView.dataSource = self
        MYPickerView.shared.isHidden = true
    }
    
    @objc func locationTapped(){
        self.txtLocation.tintColor = UIColor.clear
        self.view.endEditing(true)
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
    }
    
    func cancelClicked() {
        MYPickerView.shared.isHidden = true
    }
    
    func doneClicked() {
        if categoryCheck == 1 && CatId.count == 0 && categorylist.count > 0{
            self.lblCatgory.setTitle("   "+categorylist[0].catName, for: UIControlState.normal)
            CatId = categorylist[0].catId
            print(CatId)
        }
        else if categoryCheck == 2 && subcatId.count == 0 && subcategory.count > 0{
            self.lblSubCategory.setTitle("   "+subcategory[0].subcatName, for: UIControlState.normal)
            subcatId = subcategory[0].subcatId
            print(subcatId)
        }
        else if categoryCheck == 3 && brandId.count == 0 && brand.count > 0{
            self.lblBrandType.setTitle("   "+brand[0].brandName, for: UIControlState.normal)
            brandId = brand[0].brandId
            print(brandId)
        }
        else if categoryCheck == 4 && brandIdModel.count == 0 && model.count > 0{
            self.lblModelType.setTitle("   "+model[0].brandmodelName, for: UIControlState.normal)
            brandIdModel = model[0].brandmodelId
            print(brandIdModel)
        }
        else if categoryCheck == 5 && Invoice.count == 0 && pickerItem.count > 0{
            self.lblInvoiceAvilable.setTitle("   " + pickerItem[0], for: UIControlState.normal)
            Invoice=pickerItem[0]
        }
        MYPickerView.shared.isHidden = true
    }
    
    @IBAction func backPressButton(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }

    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func picbutton(_ sender: Any) {
        cameraClick()
        counter = 1
    }
    
    @IBAction func imagebutton(_ sender: Any) {
       cameraClick()
         counter = 2
    }
    
    @IBAction func imageThired(_ sender: Any) {
        cameraClick()
        counter = 3
    }
    
    func cameraClick(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction)in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            }else{
                
                // Create the alert controller
                let alertController = UIAlertController(title: "My World", message: "Camera not suport", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction)in
            
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        counter = 0
        
        self.present(actionSheet, animated: true, completion: nil)

    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let  chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("imagePickerController")
        if counter == 1{
            
            imageproduct1.image = chosenImage
            print("caunter call 1")
            
        }else if counter == 2{
        
            imageproduct2.image = chosenImage
            print("caunter call 2")
            
            
        }else if counter == 3{
            
            imageproduct3.image = chosenImage
            print("caunter call 3")
            
            
        }
        
        picker.dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:true, completion: nil)
    }
    
    
  
    @IBAction func btnSubmit(_ sender: Any) {
        imageData1 = (imageproduct1.image?.lowestQualityJPEGNSData)!
        imageData2 = (imageproduct2.image?.lowestQualityJPEGNSData)!
        imageData3 = (imageproduct3.image?.lowestQualityJPEGNSData)!
         let productname = txtProductName.text!
         let contactnum = txtContactNo.text!
         let price = txtProductPrice.text!
         let splprice = productSlPricce.text!
         let description = txtProductDescription.text!
         let procondition = txtProductConditon.text!
         let categoryId = CatId
         let subcategoryId = subcatId
         let invoice = Invoice
         let brandIdS = brandId
         let modelId = brandIdModel
         let loaction = txtLocation.text!
         let year = txtYear.text!
        
        SendDataToServer(productname: productname,contactnum: contactnum,price: price,splprice: splprice,description: description,procondition: procondition,categoryId: categoryId,subcategoryId: subcategoryId,invoice: invoice,brandId: brandIdS,modelId: modelId,loaction: loaction,year: year)
    }
    
    
    @objc func qtyAction(sender: UITextField) -> Void {
        
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
    
    
    
    
    @objc func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
        
    }
    

    
    @IBAction func btnSelectCat(_ sender: Any) {
        
          categoryCheck = 1
        MYPickerView.shared.isHidden = false

        MYPickerView.shared.pickerView.reloadAllComponents()
    }
    
    @IBAction func btnSubCat(_ sender: Any) {
        
        ValidateGetsubCategory(catId: CatId)
         categoryCheck = 2
         print("CatId>>>>>>",  CatId)
        MYPickerView.shared.isHidden = false

        MYPickerView.shared.pickerView.reloadAllComponents()
    }
    
    @IBAction func btnBrand(_ sender: Any) {
        
        ValidateGetBrand(subcatId: subcatId)
        categoryCheck = 3
        print("subcatId>>>>>>",  subcatId)
        MYPickerView.shared.isHidden = false

        MYPickerView.shared.pickerView.reloadAllComponents()
    }
    
    @IBAction func btnModelType(_ sender: Any) {
        
        ValidateGetModel(brandId: brandId)
        categoryCheck = 4
        print("brandId>>>>>>",  brandId)
        MYPickerView.shared.isHidden = false

        MYPickerView.shared.pickerView.reloadAllComponents()
    }
    
    @IBAction func btnInvoiceAvilable(_ sender: Any) {
        
        categoryCheck = 5
        MYPickerView.shared.isHidden = false
        MYPickerView.shared.pickerView.reloadAllComponents()

    }
    
    
    
    
    func ValidateGetCategory() {
        let urlToRequest = WEBSERVICE_URL+"getCategory.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString=""
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseHome\(String(describing: Data))") //JSONSerialization
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadcategorylist = try decoder.decode(Categorylists.self, from: data!)
                    self.categorylist = downloadcategorylist.categorylist
                    
                    
                    DispatchQueue.main.async { // Correct
                        self.categoryCheck = 1
                        MYPickerView.shared.pickerView.reloadAllComponents()

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
    
    
    
    func ValidateGetsubCategory(catId: String) {
        let urlToRequest = WEBSERVICE_URL+"getsubCategory.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="catId="+catId
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseSubCategry\(String(describing: Data))") //JSONSerialization
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadsubcategory = try decoder.decode(SubcategoryLists.self, from: data!)
                    self.subcategory = downloadsubcategory.subcategory
                    DispatchQueue.main.async { // Correct
                        self.categoryCheck = 2
                        MYPickerView.shared.pickerView.reloadAllComponents()

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
    
    func ValidateGetBrand(subcatId: String) {
        let urlToRequest = WEBSERVICE_URL+"getBrand.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="subcatId="+subcatId
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseBrand\(String(describing: Data))") //JSONSerialization
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadbrand = try decoder.decode(ResourceBrandLists.self, from: data!)
                    self.brand = downloadbrand.brand
                    DispatchQueue.main.async { // Correct
                        self.categoryCheck = 3
                        MYPickerView.shared.pickerView.reloadAllComponents()

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
    
    func ValidateGetModel(brandId: String) {
        let urlToRequest = WEBSERVICE_URL+"getbrandModel.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="brandId="+brandId
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****ResponseModel\(String(describing: Data))") //JSONSerialization
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadmodel = try decoder.decode(BrandmodelList.self, from: data!)
                    self.model = downloadmodel.model
                    DispatchQueue.main.async { // Correct
                        
                        self.categoryCheck = 4
                        MYPickerView.shared.pickerView.reloadAllComponents()

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
    
    
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if categoryCheck == 1{
            return self.categorylist.count
        }else if categoryCheck == 2{
            
            return self.subcategory.count
        }else if categoryCheck == 3{
            return self.brand.count
        }else if categoryCheck == 4{
            
            return self.model.count
        }else if categoryCheck == 5{
            return self.pickerItem.count
        }
        
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        if categoryCheck == 1{
            return self.categorylist[row].catName
        }else if categoryCheck == 2{
            
            return self.subcategory[row].subcatName
        }else if categoryCheck == 3{
             return self.brand[row].brandName
        }else if categoryCheck == 4{
             return self.model[row].brandmodelName
           
        }else if categoryCheck == 5{
            return self.pickerItem[row]
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if categoryCheck == 1{
            self.lblCatgory.setTitle("   "+categorylist[row].catName, for: UIControlState.normal)
            CatId = categorylist[row].catId
            print(CatId)
        }else if categoryCheck == 2{
            
            self.lblSubCategory.setTitle("   "+subcategory[row].subcatName, for: UIControlState.normal)
            subcatId = subcategory[row].subcatId
            print(subcatId)
        }else if categoryCheck == 3{
            
            
            self.lblBrandType.setTitle("   "+brand[row].brandName, for: UIControlState.normal)
            brandId = brand[row].brandId
            print(brandId)
        }else if categoryCheck == 4{
            self.lblModelType.setTitle("   "+model[row].brandmodelName, for: UIControlState.normal)
            brandIdModel = model[row].brandmodelId
            print(brandIdModel)
        }else if categoryCheck == 5{
            self.lblInvoiceAvilable.setTitle("   " + pickerItem[row], for: UIControlState.normal)

            Invoice=pickerItem[row]
        }
        
      
    }
    

    //*******************************************************************
    
    

    
    func SendDataToServer(productname: String,contactnum:String,price: String,splprice:String,description:String,procondition:String,categoryId:String,subcategoryId:String,invoice:String,brandId:String,modelId:String,loaction:String,year:String) -> Void {
        let param = [
            "postedBy" : UserDefaults.standard.string(forKey: "userId"),
            "productName": productname,
            "contactNum": contactnum,
            "productPrice": price,
            "productsplPrice":splprice,
            "productDesp":description,
            "productCondition":procondition,
            "catId":categoryId,
            "subcatId":subcategoryId,
            "invoice":invoice,
            "brandId":brandId,
            "brandmodelId":modelId,
            "location": loaction,
            "productYear": year]
        SVProgressHUD.show(withStatus: "Loading")
       
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if self.imageData1.length == 0{
                
            }else{
                
                    multipartFormData.append(self.imageData1 as Data, withName: "productImage1", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
    
                    multipartFormData.append(self.imageData2 as Data, withName: "productImage2", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                
                 multipartFormData.append(self.imageData3 as Data, withName: "productImage3", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in param {
                
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key )
                
            }
            
        }, to: WEBSERVICE_URL + "adduserProduct.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("progress \(progress) " )
                    
                })
                
                upload.responseJSON { response in
                    //print response.result
                    print("response data \(response) " )
                    SVProgressHUD.dismiss()

                    let jsonResponse = response.result.value as! NSDictionary
                    if jsonResponse.value(forKey: "responseCode") as! String == "200"{
                        DispatchQueue.main.async(execute: {
                            let alertController = UIAlertController(title: "Image", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                           
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                // Do whatever you want with inputTextField?.text
                                self.navigationController?.popViewController(animated:true)
                            })
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                            
                        })
                    }else{
                        DispatchQueue.main.async(execute: {
                            let alertController = UIAlertController(title: "Myworld", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                // Do whatever you want with inputTextField?.text
                            })
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                        })
                    }
                }
                
            case .failure( _):
                SVProgressHUD.dismiss()
                break
                //print encodingError.description
                
            }
        }
    }
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        txtLocation.text = place.formattedAddress
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

}

class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}



