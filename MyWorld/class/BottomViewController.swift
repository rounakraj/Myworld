//
//  BottomViewController.swift
//  MyWorld
//
//  Created by MyWorld on 21/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class BottomViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    @IBOutlet weak var containerView: UIView!
    static var containerViewS = UIView()
    @IBOutlet  weak var bottomView: UIView!
    static var sharedURLSessio = UIView()
    
    var imageData = NSData()
    let picker = UIImagePickerController()   //our controller.
    
    @IBAction func chatButton(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ChatFriendViewController") as! ChatFriendViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        
        takePhotoAction()
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
    
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,
                completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageData = UIImagePNGRepresentation(chosenImage)! as NSData
        dismiss(animated:true, completion: nil) //5
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "SelectFriendsViewController") as! SelectFriendsViewController
        controller.imageData = imageData
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    
    @IBAction func MyPageButton(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
        let controller = MainStoryboard.instantiateViewController(withIdentifier: "MyPosts") as! MyPosts
        self.navigationController?.pushViewController(controller, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BottomViewController.containerViewS = containerView
        BottomViewController.sharedURLSessio = bottomView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
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
    
    static  func view() {
        sharedURLSessio.isHidden = true
        
    }
    
    
    
    
}

