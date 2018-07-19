//
//  BootomBar.swift
//  MyWorld
//
//  Created by Shankar Kumar on 25/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
protocol BootomDelegate {
    func chatClicked()
    func cameraClicked()
    func myPostClicked()
    func myContactClicked()
    func myCrossClicked()

    func getImage(imageData:NSData)
    func getVideoesData(videoesData:NSData,thumb_nail:NSData)

}

class BootomBar: UIView,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    var imageData = NSData()
    var videoData = NSURL()
    var videoesData = NSData()
    var thumb_nail = NSData()
    let saveFileName = "/myworld.mp4"
    var chkVideo = String()
    let picker = UIImagePickerController()
    var delegate:BootomDelegate?
    
    static let shared:BootomBar = {
        let shared = Bundle.main.loadNibNamed("BootomBar", owner: self, options: nil)?.first as? BootomBar
       if UIScreen.main.nativeBounds.height == 2436{
            shared?.frame = CGRect(x:0, y: (AppDelegate.getAppDelegate().window?.frame.size.height)!-74, width: (AppDelegate.getAppDelegate().window?.frame.size.width)!, height: 64.0)
            shared?.dropShadow()
        }
        else{
            shared?.frame = CGRect(x:0, y: (AppDelegate.getAppDelegate().window?.frame.size.height)!-44, width: (AppDelegate.getAppDelegate().window?.frame.size.width)!, height: 44.0)
            shared?.dropShadow()
        }
        return shared!
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func firstBtnAction(_ sender: Any) {
        delegate?.chatClicked()
    }
    @IBAction func secondBtnAction(_ sender: Any) {
        delegate?.myContactClicked()
    }
    @IBAction func thirdBtnAction(_ sender: Any) {
        delegate?.cameraClicked()
    }
    @IBAction func fourthBtnAction(_ sender: Any) {
        delegate?.myCrossClicked()
    }
    @IBAction func lastBtnAction(_ sender: Any) {
        delegate?.myPostClicked()
    }
    
    func hideBootomBar() {
        self.isHidden = true
    }
    func showBootomBar() {
        self.isHidden = false
    }
    
    
    //MARK: - Actions
    //get a photo from the library. We present as a popover on iPad, and fullscreen on smaller devices.
    func photoFromLibrary(controller:UIViewController) {
        picker.allowsEditing = false //2
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary //3
        picker.modalPresentationStyle = .popover
        picker.delegate = self
        
        controller.present(picker,
                animated: true,
                completion: nil)//4
    }
    
    //take a picture, check if we have a camera first.
    func shootPhoto(controller:UIViewController) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            controller.present(picker,
                    animated: true,
                    completion: nil)
        }
    }
    //get a video from the library. We present as a popover on iPad, and fullscreen on smaller devices.
    func videoFromLibrary(controller:UIViewController) {
        chkVideo = "1"
        picker.allowsEditing = false //2
        picker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum //3
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        
         controller.present(picker,
                animated: true,
                completion: nil)//4
    }
    
    //get a Record video We present as a popover on iPad, and fullscreen on smaller devices.
   func recordingVideo(controller:UIViewController) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            chkVideo = "2"
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.allowsEditing = false
            picker.delegate = self
            controller.present(picker, animated: true, completion: {})
            
        }
    }
    
    func getThumbnailFrom(path: URL) -> UIImage{
        var thumbnail = UIImage()
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return thumbnail
            
        }
        
    }
    // Any tasks you want to perform after recording a video
    @objc func videoWasSavedSuccessfully(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                // What you want to happen
            })
        }
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,
                completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if chkVideo == "1"{
            if let pickedVideo:URL = (info[UIImagePickerControllerMediaURL] as? URL) {
                // Save video to the main photo album
                
                    let selectorToCall = #selector(BootomBar.videoWasSavedSuccessfully(_:didFinishSavingWithError:context:))
                    UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath, self, selectorToCall, nil)
                
                    // Save the video to the app directory so we can play it later
                    let videoData = try? Data(contentsOf: pickedVideo)
                
                    let paths = NSSearchPathForDirectoriesInDomains(
                        FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                    let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
                    let dataPath = documentsDirectory.appendingPathComponent(saveFileName)
                    try! videoData?.write(to: dataPath, options: [])
                    videoesData = try!NSData(contentsOf: pickedVideo as URL)
                
                    self.thumb_nail = (self.getThumbnailFrom(path: self.videoData as URL).lowestQualityJPEGNSData)
                
                    delegate?.getVideoesData(videoesData: videoesData,thumb_nail: thumb_nail)
                
                print("Saved to " + dataPath.absoluteString)
                }
        }else if chkVideo == "2" {
    
            videoData = info[UIImagePickerControllerMediaURL] as! NSURL //2
            videoesData = try!NSData(contentsOf: videoData as URL)
            self.thumb_nail = (self.getThumbnailFrom(path: self.videoData as URL).lowestQualityJPEGNSData)
            delegate?.getVideoesData(videoesData: videoesData,thumb_nail: thumb_nail)
            picker.dismiss(animated:true, completion: nil) //5
        } else {
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
            imageData = UIImagePNGRepresentation(chosenImage)! as NSData
            picker.dismiss(animated:true, completion: nil) //5
            delegate?.getImage(imageData: imageData)
         }
    }

}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
