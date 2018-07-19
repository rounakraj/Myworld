//
//  NewPostViewController.swift
//  MyWorld
//
//  Created by MyWorld on 10/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Social
import FBSDKShareKit
import FBSDKCoreKit

class NewPostViewController: UIViewController{

    @IBOutlet weak var imgePostImageView: UIImageView!
    @IBOutlet weak var txtStatus: UITextField!

     var imageData = NSData()
     let picker = UIImagePickerController()   //our controller.
    var from = String()
    var videoURL = NSData()
    var isBoxclickde:Bool!
    let saveFileName = "/myworld.mp4"
    @IBAction func btnBackpress(_ sender: Any) {
        
         navigationController?.popViewController(animated:true)
         BottomViewController.sharedURLSessio.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        BottomViewController.sharedURLSessio.isHidden = true
        debugPrint("\(Date().timeIntervalSince1970).jpeg")
    }
    
    
    @IBAction func btnCamera(_ sender: Any) {
        isBoxclickde = false
        takePhotoAction()
    }
    
    
    @IBAction func btnVideo(_ sender: Any) {
        isBoxclickde = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.mediaTypes = ["public.movie"]
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func btnPost(_ sender: Any) {
        
        if from == "1"{
            
            SendDataToServerUpdateUserStatus()
        }else{
            SendDataToServerUpdateGlobalStatus()
        }
    }
    
    
    @IBAction func shareFacebook(_ sender: Any) {
        
       /* let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "") as URL!
        let shareDialog = FBSDKShareDialog()
        shareDialog.mode = .automatic
        shareDialog.shareContent = content
        shareDialog.show()
        print(txtStatus.text)
        //YMSocialShare.shareOn(serviceType:.otherApps,text:"Checkout My World application. Download from Android PlayStore or iOS Appstore",image:#imageLiteral(resourceName: "logo"))*/
        let photo : FBSDKSharePhoto = FBSDKSharePhoto()
        photo.image = imgePostImageView.image
        photo.isUserGenerated = true
        let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        content.photos = [photo]
        let shareDialog = FBSDKShareDialog()
        shareDialog.mode = .automatic
        shareDialog.shareContent = content
        shareDialog.show()
    }
    
    @objc func takePhotoAction() {
       
        let alertView = UIAlertController(title: "Choose Option", message: "Add a picture", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            self.shootPhoto()
        })
        let library = UIAlertAction(title: "Library", style: .default, handler: { (alert) in
            self.photoFromLibrary()
        })
    
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            
        })
        alertView.addAction(camera)
        alertView.addAction(library)
        alertView.addAction(Cancel)
        
        self.present(alertView, animated: true, completion: nil)
    }
    @objc func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    //MARK: - Actions
    //get a photo from the library. We present as a popover on iPad, and fullscreen on smaller devices.
    @IBAction func photoFromLibrary() {
        picker.allowsEditing = false //2
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary //3
        picker.modalPresentationStyle = .popover
        picker.delegate = self
        
        present(picker,
                animated: true,
                completion: nil)//4
    }
    
    //take a picture, check if we have a camera first.
    @IBAction func shootPhoto() {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,
                    animated: true,
                    completion: nil)
        } else {
            noCamera()
        }
    }
    func SendDataToServerUpdateUserStatus() -> Void {
        if self.imageData.length == 0 && self.videoURL == nil && self.txtStatus.text?.count == 0{
            SVProgressHUD.showInfo(withStatus: "Please select image/video/Status")
            return
        }
        let param = ["userId" : UserDefaults.standard.string(forKey: "userId"),"userStatus" : txtStatus.text]

        SVProgressHUD.show(withStatus: "Loading")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if self.imageData.length == 0 {
                
            }else{
                
                if self.imageData.length > 0 {
                    multipartFormData.append(self.imageData as Data, withName: "userFile", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }else{
                    multipartFormData.append(self.videoURL as Data, withName: "userFile", fileName: "\(Date().timeIntervalSince1970).mp4", mimeType: "video/mp4")

                }
                
            }
            for (key, value) in param {
                
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key )
                
            }
            
        }, to: WEBSERVICE_URL + "updateUserStatus.php")
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
                    
                    let jsonResponse = response.result.value as! NSDictionary
                    if jsonResponse.value(forKey: "responseCode") as! String == "200"{
                        DispatchQueue.main.async(execute: {
                            
                            SVProgressHUD.dismiss()
                            let alertController = UIAlertController(title: "My World", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                            SVProgressHUD.dismiss()
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
                            SVProgressHUD.dismiss()
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
    
    
    func SendDataToServerUpdateGlobalStatus() -> Void {
        
        if self.imageData.length == 0 && self.videoURL == nil && self.txtStatus.text?.count == 0{
            SVProgressHUD.showInfo(withStatus: "Please select image/video/Status")
            return
        }
        let param = ["userId" : UserDefaults.standard.string(forKey: "userId"),"globalStatus" : txtStatus.text]

       SVProgressHUD.show(withStatus: "Loading")
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if self.imageData.length == 0 {
                
            }else{
                if self.imageData.length > 0{
                multipartFormData.append(self.imageData as Data, withName: "globalFile", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }else{
                    multipartFormData.append(self.videoURL as Data, withName: "globalFile", fileName: "\(Date().timeIntervalSince1970).mp4", mimeType: "video/mp4")
                }
            }
            for (key, value) in param {
                
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key )
                
            }
            
        }, to: WEBSERVICE_URL + "updateGlobalStatus.php")
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
                    let jsonResponse = response.result.value as! NSDictionary
                    if jsonResponse.value(forKey: "responseCode") as! String == "200"{
                        DispatchQueue.main.async(execute: {
                            
                            SVProgressHUD.dismiss()
                            let alertController = UIAlertController(title: "Image", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                            SVProgressHUD.dismiss()
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
                            SVProgressHUD.dismiss()
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
    
    
}

extension NewPostViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            if mediaType == "public.movie" {
                print("Video Selected")
                  if let pickedVideo:URL = (info[UIImagePickerControllerMediaURL] as? URL) {
                    
                    let videoData = try? Data(contentsOf: pickedVideo)
                    let paths = NSSearchPathForDirectoriesInDomains(
                        FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                    let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
                    let dataPath = documentsDirectory.appendingPathComponent(saveFileName)
                    try! videoData?.write(to: dataPath, options: [])
                    videoURL = try!NSData(contentsOf: pickedVideo as URL)
                
                //videoURL = info[UIImagePickerControllerMediaURL] as? URL
                }
            }else{
                let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
                
                imgePostImageView.contentMode = .scaleAspectFill //
                imgePostImageView.image = chosenImage
                imageData = (imgePostImageView.image?.lowestQualityJPEGNSData)!
                
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
