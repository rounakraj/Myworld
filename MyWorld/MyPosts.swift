////
//  MyPosts.swift
//  MyWorld
//
//  Created by Shankar Kumar on 07/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD
import FBSDKShareKit
import FBSDKCoreKit


class MyPosts: UIViewController,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PKCCropDelegate,PlayerViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    var isProfileUpdate = false
    let picker = UIImagePickerController()
    var imageData = NSData()
    var networkUpdateArray = NSArray()
    var shareUpdateArray = NSArray()
    var detailsDict = NSDictionary()
    var isKeyboardDismiss:Bool = false
    var isImageZoomed:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        //getMyProfileDetailData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.isImageZoomed{
            self.isImageZoomed = false
        }
        else{
          getMyProfileDetailData()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func backFromPlayerView(url: String) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
        let obj = MainStoryboard.instantiateViewController(withIdentifier: "ChatVideoController") as! ChatVideoController
        obj.urlStr = url
        obj.isFromMyPost = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @objc func imagePreview(_ sender:UITapGestureRecognizer){
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
        let obj = MainStoryboard.instantiateViewController(withIdentifier: "ImagePreviewViewController") as! ImagePreviewViewController
        let tapLocation = sender.location(in: self.tableView)
        let indexPath:NSIndexPath = self.tableView.indexPathForRow(at: tapLocation)! as NSIndexPath
        if indexPath.section == 3{
           obj.urlStr = (networkUpdateArray[indexPath.row] as! NSDictionary).object(forKey: "userFile") as? String
        }
        if indexPath.section == 4{
          obj.urlStr = (shareUpdateArray[indexPath.row] as! NSDictionary).object(forKey: "globalFile") as? String
        }
        self.isImageZoomed = true
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @objc func goToProfile(_ sender:UITapGestureRecognizer){
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let tapLocation = sender.location(in: self.tableView)
        let indexPath:NSIndexPath = self.tableView.indexPathForRow(at: tapLocation)! as NSIndexPath
        if indexPath.section == 3{
            desCV.userId = (networkUpdateArray[indexPath.row] as! NSDictionary).object(forKey: "userId") as! String
        }
        if indexPath.section == 4{
            desCV.userId = (shareUpdateArray[indexPath.row] as! NSDictionary).object(forKey: "userId") as! String
        }
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @objc func shareContentAction(sender:UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)! as NSIndexPath
        let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! MyPostTVC
        let dic = NSDictionary()
        print("Test =\(indexPath)")
        if indexPath.section == 3{
            print("Test = \(networkUpdateArray[indexPath.row] as! NSDictionary)")
            let dic = networkUpdateArray[indexPath.row] as! NSDictionary
            let file = dic.object(forKey: "globalFile") as? NSString
            if file == ""{
                let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
                content.quote = dic.object(forKey: "globalStatus") as! String
                let shareDialog = FBSDKShareDialog()
                shareDialog.mode = .automatic
                shareDialog.shareContent = content
                shareDialog.show()
            }
            else{
                if file?.pathExtension == "jpeg" ||  file?.pathExtension == "jpg"{
                    let photo : FBSDKSharePhoto = FBSDKSharePhoto()
                    photo.image = cell.postImageView.image == nil ? cell.postImageTextView.image :   cell.postImageView.image
                    photo.isUserGenerated = true
                    let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
                    content.photos = [photo]
                    let shareDialog = FBSDKShareDialog()
                    shareDialog.mode = .automatic
                    shareDialog.shareContent = content
                    shareDialog.show()
                }
                else{
                    let content = FBSDKShareLinkContent()
                    content.quote = dic.object(forKey: "globalStatus") as! String
                    let shareDialog = FBSDKShareDialog()
                    shareDialog.mode = .automatic
                    shareDialog.shareContent = content
                    shareDialog.show()
                }
            }
        }
        if indexPath.section == 4 {
          print("Test = \(shareUpdateArray[indexPath.row] as! NSDictionary)")
            let dic = shareUpdateArray[indexPath.row] as! NSDictionary
            let file = dic.object(forKey: "globalFile") as? NSString
            if file == ""{
                 let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
                 content.quote = dic.object(forKey: "globalStatus") as! String
                 let shareDialog = FBSDKShareDialog()
                 shareDialog.mode = .automatic
                 shareDialog.shareContent = content
                 shareDialog.show()
            }
            else{
                if file?.pathExtension == "jpeg" ||  file?.pathExtension == "jpg"{
                    let photo : FBSDKSharePhoto = FBSDKSharePhoto()
                    photo.image = cell.postImageView.image == nil ? cell.postImageTextView.image :   cell.postImageView.image
                    photo.isUserGenerated = true
                    let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
                    content.photos = [photo]
                    let shareDialog = FBSDKShareDialog()
                    shareDialog.mode = .automatic
                    shareDialog.shareContent = content
                    shareDialog.show()
                }
                else{
                    let content = FBSDKShareLinkContent()
                    content.quote = dic.object(forKey: "globalStatus") as! String
                    let shareDialog = FBSDKShareDialog()
                    shareDialog.mode = .automatic
                    shareDialog.shareContent = content
                    shareDialog.show()
                }
            }
        }
    }
    
    @objc func selectShareAction(sender: UIButton) -> Void {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        let buttonTag = sender.tag
        print(buttonTag)
        if case buttonTag = 2
        {
            if let userFile = self.detailsDict.value(forKey: "userFile") as? String, let userStatus = self.detailsDict.value(forKey: "userStatus") as? String {
                if userFile.count > 0 && userStatus.count > 0{
                    let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
                    content.contentURL = NSURL(string: userFile) as URL!
                    let shareDialog = FBSDKShareDialog()
                    shareDialog.mode = .automatic
                    shareDialog.shareContent = content
                    shareDialog.show()
                }
                else
                {
                    let photo : FBSDKSharePhoto = FBSDKSharePhoto()
                    photo.image = UIImage(named:"logo.png")!
                    photo.isUserGenerated = true
                    let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
                    content.photos = [photo]
                    let shareDialog = FBSDKShareDialog()
                    shareDialog.mode = .automatic
                    shareDialog.shareContent = content
                    shareDialog.show()
                    
                }
            }
        }
        else
        {
            var dict = NSDictionary()
            dict = networkUpdateArray[(indexPath?.row)!] as! NSDictionary
            if let userFile = dict.value(forKey: "userFile") as? String {
                if userFile.count > 0
                {
                    print(userFile)
                    let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
                    content.contentURL = NSURL(string: userFile) as URL!
                    let shareDialog = FBSDKShareDialog()
                    shareDialog.mode = .automatic
                    shareDialog.shareContent = content
                    shareDialog.show()
                    
                }
                else
                {
                    let photo : FBSDKSharePhoto = FBSDKSharePhoto()
                    photo.image = UIImage(named:"logo.png")!
                    photo.isUserGenerated = true
                    let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
                    content.photos = [photo]
                    let shareDialog = FBSDKShareDialog()
                    shareDialog.mode = .automatic
                    shareDialog.shareContent = content
                    shareDialog.show()
                }
                
            }
            
        }
        
    }
    

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 3{
         return networkUpdateArray.count
        }else if section == 4{
            return shareUpdateArray.count

        }else if section == 2{
            if let userFile = self.detailsDict.value(forKey: "userFile") as? String, let userStatus = self.detailsDict.value(forKey: "userStatus") as? String {
                if userFile.count > 0 || userStatus.count > 0{
                return 1
                }else{
                    return 0
                }
            
        }else{
            return 0
            }
        }
        else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view:UIView? = nil
        view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))

        let label = UILabel(frame: CGRect(x: 0, y: 0, width:  tableView.frame.size.width, height: 30))
        label.textColor = UIColor.gray
        label.textAlignment = .center
        view?.addSubview(label)
        
        if section == 3 {
            label.text = "Network Update"

        }else if section == 4{
            
            label.text = "Shared Update"
           
        }else {

        }
    
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 || section == 4 {
             return 30
        }else {
             return 0
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MyPostTVC()
        if indexPath.section == 0 {
            print("0")
            cell = tableView.dequeueReusableCell(withIdentifier: "profile", for: indexPath) as! MyPostTVC
            cell.profileImage.clipsToBounds = true
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height/2
            cell.profileImage.layer.borderWidth = 0.8
            cell.profileImage.layer.borderColor = UIColor.white.cgColor
            cell.changeProfileImageBtn.addTarget(self, action: #selector(takePhotoAction(_:)), for: .touchUpInside)
            cell.changeBackBtn.addTarget(self, action: #selector(takePhotoAction(_:)), for: .touchUpInside)
            if let profileImage = self.detailsDict.value(forKey: "profileImage") as? String {
                cell.profileImage.sd_setImage(with: URL(string:profileImage), placeholderImage:UIImage(named: "ic_profile"))
                UserDefaults.standard.set(profileImage, forKey: "profileImage")
            }
            if let coverImage = self.detailsDict.value(forKey: "coverImage") as? String {
                cell.profileBackGroundImage.sd_setImage(with: URL(string:coverImage), placeholderImage:#imageLiteral(resourceName: "menutop"))
            }
            cell.username.text = UserDefaults.standard.string(forKey: "firstName")!+" "+UserDefaults.standard.string(forKey: "lastName")!
        }
        else if indexPath.section == 1 {
              print("1")
            cell = tableView.dequeueReusableCell(withIdentifier: "status", for: indexPath) as! MyPostTVC
            cell.newPostBtn.addTarget(self, action: #selector(callController), for: .touchUpInside)
        }
        else if indexPath.section == 2 {
              print("2")
            cell = tableView.dequeueReusableCell(withIdentifier: "myVideo", for: indexPath) as! MyPostTVC
            cell.updatesProfileImage.clipsToBounds = true
            cell.updatesProfileImage.layer.cornerRadius = cell.updatesProfileImage.frame.size.height/2
            cell.updatesProfileImage.layer.borderWidth = 0.8
            cell.updatesProfileImage.layer.borderColor = UIColor.white.cgColor
            cell.updatesProfileImage.isUserInteractionEnabled = false
            cell.inviteBtn.isHidden = true
            cell.postImageTextView.isUserInteractionEnabled = false
            cell.postImageView.isUserInteractionEnabled = false
            cell.shareContentBtn.isHidden = true

            if let profileImage = self.detailsDict.value(forKey: "profileImage") as? String {
                cell.updatesProfileImage.sd_setImage(with: URL(string:profileImage), placeholderImage:UIImage(named: "ic_profile"))
            }
          
            cell.updateUserName.text = UserDefaults.standard.string(forKey: "firstName")!+" "+UserDefaults.standard.string(forKey: "lastName")!

            
            if let userTime = self.detailsDict.value(forKey: "userTime") as? String {
                cell.updateDate.text = userTime
                
            }else
            {
                cell.updateDate.text = ""
            }
            
            if let userFile = self.detailsDict.value(forKey: "userFile") as? String,
                let userStatus = self.detailsDict.value(forKey: "userStatus") as? String {
                if userFile.count > 0 && userStatus.count > 0{
                    if userFile.characters.last! == "4" {
                        var myCustomView: PlayerView? // declare variable inside your controller
                        if myCustomView == nil { // make it only once
                            myCustomView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as? PlayerView
                            myCustomView?.delegate = self
                            myCustomView?.frame = cell.videoBackView.layer.bounds
                            myCustomView?.setUpview(url: userFile)
                            
                            cell.postTextView.text = userStatus
                            cell.imageTextVideoBackView.addSubview(myCustomView!) // you can omit 'self' here
                            cell.imageTextVideoBackView.isHidden = false
                            cell.postImageTextView.isHidden = true
                        }
                    }else {
                        
                        cell.postTextView.text = userStatus
                        cell.postImageTextView.sd_setImage(with: URL(string:userFile), placeholderImage:#imageLiteral(resourceName: "menutop"))
                        cell.imageTextVideoBackView.isHidden = true
                        cell.postImageTextView.isHidden = false
                    }
                    cell.imageBackView.isHidden = true
                    cell.videoBackView.isHidden = true;
                    cell.imageTextBackView.isHidden = false;
                    //cell.bottomView.isHidden = true //ravinder
                }
                else if userFile.count > 0 {
                    
                    if userFile.characters.last! == "4" {
                        var myCustomView: PlayerView? // declare variable inside your controller
                        if myCustomView == nil { // make it only once
                            myCustomView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as? PlayerView
                             myCustomView?.delegate = self
                            myCustomView?.frame = CGRect.init(x: 0, y: 0, width: cell.videoBackView.frame.size.width, height: 190)
                            myCustomView?.setUpview(url: userFile)
                            cell.videoBackView.addSubview(myCustomView!) // you can omit 'self' here
                            cell.imageBackView.isHidden = true
                            cell.videoBackView.isHidden = false;
                            cell.imageTextBackView.isHidden = true;
                        }
                    }
                    else {
                        cell.postTextView.text = userStatus
                        cell.postImageView.sd_setImage(with: URL(string:userFile), placeholderImage:#imageLiteral(resourceName: "menutop"))
                        cell.imageBackView.isHidden = false
                        cell.videoBackView.isHidden = true;
                        cell.imageTextBackView.isHidden = true;
                    }
                     //cell.bottomView.isHidden = false //ravinder
                }
                else if userStatus.count > 0{
                    //cell.bottomView.isHidden = true //ravinder
                    cell.postTextView.text = userStatus
                    cell.imageBackView.isHidden = true
                    cell.videoBackView.isHidden = true;
                    cell.imageTextBackView.isHidden = false;
                }
                else {
                    //cell.bottomView.isHidden = true //ravinder
                    cell.imageBackView.isHidden = true
                    cell.videoBackView.isHidden = true;
                    cell.imageTextBackView.isHidden = true;
                }
            }
        }
        else if indexPath.section == 3 {
              print("3")
            cell = tableView.dequeueReusableCell(withIdentifier: "myVideo", for: indexPath) as! MyPostTVC
            cell.updatesProfileImage.clipsToBounds = true
            cell.updatesProfileImage.layer.cornerRadius = cell.updatesProfileImage.frame.size.height/2
            cell.updatesProfileImage.layer.borderWidth = 0.8
            cell.updatesProfileImage.layer.borderColor = UIColor.white.cgColor
            cell.updatesProfileImage.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MyPosts.goToProfile(_:)))
             cell.updatesProfileImage.addGestureRecognizer(tapGesture)
            
            
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(MyPosts.imagePreview(_:)))
            cell.postImageTextView.isUserInteractionEnabled = true
            cell.postImageTextView.addGestureRecognizer(tapGesture1)
            let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(MyPosts.imagePreview(_:)))
            cell.postImageView.isUserInteractionEnabled = true
            cell.postImageView.addGestureRecognizer(tapGesture2)
            
            cell.inviteBtn.isHidden = true
            cell.shareContentBtn.isHidden = false
            cell.shareContentBtn.addTarget(self, action: #selector(shareContentAction(sender:)), for: .touchUpInside)
            
            var dict = NSDictionary()
            dict = networkUpdateArray[indexPath.row] as! NSDictionary
            
            if let profileImage = dict.value(forKey: "profileImage") as? String {
                cell.updatesProfileImage.sd_setImage(with: URL(string:profileImage), placeholderImage: UIImage(named: "ic_profile"))
            }
            if let userName = dict.value(forKey: "userName") as? String {
                cell.updateUserName.text = userName
            }
            else{
                cell.updateUserName.text = ""
            }
            if let userTime = dict.value(forKey: "userTime") as? String {
                cell.updateDate.text = userTime
            }
            else{
                cell.updateDate.text = ""
            }
            
            if let userFile = dict.value(forKey: "userFile") as? String, let userStatus = dict.value(forKey: "userStatus") as? String {
                if userFile.count > 0 && userStatus.count > 0{
                    if userFile.characters.last! == "4" {
                        var myCustomView: PlayerView? // declare variable inside your controller
                        if myCustomView == nil { // make it only once
                            myCustomView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as? PlayerView
                             myCustomView?.delegate = self
                            myCustomView?.frame = CGRect.init(x: 0, y: 68, width: cell.videoBackView.frame.size.width, height: 190)
                            myCustomView?.setUpview(url: userFile)
                            cell.postTextView.text = userStatus
                            cell.imageTextVideoBackView.addSubview(myCustomView!) // you can omit 'self' here
                            cell.imageTextVideoBackView.isHidden = false
                            cell.postImageTextView.isHidden = true
                        }
                    }else {
                        cell.postTextView.text = userStatus
                        cell.postImageTextView.sd_setImage(with: URL(string:userFile), placeholderImage:#imageLiteral(resourceName: "menutop"))
                        cell.imageTextVideoBackView.isHidden = true
                        cell.postImageTextView.isHidden = false
                    }
                    cell.imageBackView.isHidden = true
                    cell.videoBackView.isHidden = true;
                    cell.imageTextBackView.isHidden = false;
                    //cell.bottomView.isHidden = true //ravinder
                }else if userFile.count > 0 {
                    
                    if userFile.characters.last! == "4" {
                        var myCustomView: PlayerView? // declare variable inside your controller
                        if myCustomView == nil { // make it only once
                            myCustomView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as? PlayerView
                             myCustomView?.delegate = self
                            myCustomView?.frame = CGRect.init(x: 0, y: 0, width: cell.videoBackView.frame.size.width, height: 190)
                            myCustomView?.setUpview(url: userFile)
                            cell.videoBackView.addSubview(myCustomView!) // you can omit 'self' here
                            cell.imageBackView.isHidden = true
                            cell.videoBackView.isHidden = false;
                            cell.imageTextBackView.isHidden = true;
                        }
                    }else {
                        cell.postTextView.text = userStatus
                        cell.postImageView.sd_setImage(with: URL(string:userFile), placeholderImage:#imageLiteral(resourceName: "menutop"))
                        cell.imageBackView.isHidden = false
                        cell.videoBackView.isHidden = true;
                        cell.imageTextBackView.isHidden = true;
                    }
                   //cell.bottomView.isHidden = false //ravinder
                }
                else if userStatus.count > 0{
                    //cell.bottomView.isHidden = true //ravinder
                    cell.postTextView.text = userStatus
                    cell.imageBackView.isHidden = true
                    cell.videoBackView.isHidden = true;
                    cell.imageTextBackView.isHidden = false;
                }else {
                     //cell.bottomView.isHidden = true //ravinder
                    cell.imageBackView.isHidden = true
                    cell.videoBackView.isHidden = true;
                    cell.imageTextBackView.isHidden = true;
                }
            }
        }
        else if indexPath.section == 4 {
              print("4")
            cell = tableView.dequeueReusableCell(withIdentifier: "myVideo", for: indexPath) as! MyPostTVC
            //test
            cell.updatesProfileImage.clipsToBounds = true
            cell.updatesProfileImage.layer.cornerRadius = cell.updatesProfileImage.frame.size.height/2
            cell.updatesProfileImage.layer.borderWidth = 0.8
            cell.updatesProfileImage.layer.borderColor = UIColor.white.cgColor
            cell.updatesProfileImage.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MyPosts.goToProfile(_:)))
             cell.updatesProfileImage.addGestureRecognizer(tapGesture)
            
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(MyPosts.imagePreview(_:)))
            cell.postImageTextView.isUserInteractionEnabled = true
            cell.postImageTextView.addGestureRecognizer(tapGesture1)
            let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(MyPosts.imagePreview(_:)))
            cell.postImageView.isUserInteractionEnabled = true
            cell.postImageView.addGestureRecognizer(tapGesture2)
            
            
            cell.inviteBtn.layer.borderWidth = 0.8
            cell.inviteBtn.layer.cornerRadius = 5.0
            cell.inviteBtn.layer.borderColor = UIColor.gray.cgColor
            cell.inviteBtn.addTarget(self, action: #selector(selectAction(sender:)), for: .touchUpInside)
            cell.inviteBtn.isHidden = false
            cell.shareContentBtn.addTarget(self, action: #selector(shareContentAction(sender:)), for: .touchUpInside)
            
            var dict = NSDictionary()
            dict = shareUpdateArray[indexPath.row] as! NSDictionary
            if dict.object(forKey: "is_invited") as! String == "No"{
             cell.inviteBtn.setTitle("Invite friend", for: .normal)
            }
            else{
             cell.inviteBtn.setTitle("UnInvite friend", for: .normal)
            }
            
            if let profileImage = dict.value(forKey: "profileImage") as? String {
                cell.updatesProfileImage.sd_setImage(with: URL(string:profileImage), placeholderImage: UIImage(named: "ic_profile"))
            }
            if let userName = dict.value(forKey: "userName") as? String {
                print("Test = \(userName)")
                cell.updateUserName.text = userName
            }
            if let globalTime = dict.value(forKey: "globalTime") as? String {
                cell.updateDate.text = globalTime
            }
            else{
                 cell.updateDate.text = ""
            }
            if let userFile = dict.value(forKey: "globalFile") as? String, let userStatus = dict.value(forKey: "globalStatus") as? String {
                if userFile.count > 0 && userStatus.count > 0{
                    if userFile.characters.last! == "4" {
                        var myCustomView: PlayerView? // declare variable inside your controller
                        if myCustomView == nil { // make it only once
                            myCustomView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as? PlayerView
                             myCustomView?.delegate = self
                            myCustomView?.frame = CGRect.init(x: 0, y: 68, width: cell.videoBackView.frame.size.width, height: 190)
                            myCustomView?.setUpview(url: userFile)
                            cell.postTextView.text = userStatus
                            cell.imageTextVideoBackView.addSubview(myCustomView!) // you can omit 'self' here
                            cell.imageTextVideoBackView.isHidden = false
                            cell.postImageTextView.isHidden = true
                        }
                    }
                    else {
                        cell.postTextView.text = userStatus
                        cell.postImageTextView.sd_setImage(with: URL(string:userFile), placeholderImage:#imageLiteral(resourceName: "menutop"))
                        cell.imageTextVideoBackView.isHidden = true
                        cell.postImageTextView.isHidden = false
                    }
                    cell.imageBackView.isHidden = true
                    cell.videoBackView.isHidden = true;
                    cell.imageTextBackView.isHidden = false;
                    //cell.bottomView.isHidden = true //ravinder
                }
                else if userFile.count > 0 {
                    if userFile.characters.last! == "4" {
                        var myCustomView: PlayerView? // declare variable inside your controller
                        if myCustomView == nil { // make it only once
                            myCustomView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as? PlayerView
                             myCustomView?.delegate = self
                            myCustomView?.frame = CGRect.init(x: 0, y: 0, width: cell.videoBackView.frame.size.width, height: 190)
                            myCustomView?.setUpview(url: userFile)
                            cell.videoBackView.addSubview(myCustomView!) // you can omit 'self' here
                            cell.imageBackView.isHidden = true
                            cell.videoBackView.isHidden = false;
                            cell.imageTextBackView.isHidden = true;
                        }
                    }
                    else {
                        cell.postTextView.text = userStatus
                        print("Image = \(userFile)")
                        cell.postImageView.sd_setImage(with: URL(string:userFile), placeholderImage:#imageLiteral(resourceName: "menutop"))
                        cell.imageBackView.isHidden = false
                        cell.videoBackView.isHidden = true;
                        cell.imageTextBackView.isHidden = true;
                    }
                   //cell.bottomView.isHidden = false //ravinder
                }
                else if userStatus.count > 0{
                    //cell.bottomView.isHidden = true //ravinder
                    cell.postTextView.text = userStatus
                    cell.imageBackView.isHidden = true
                    cell.videoBackView.isHidden = true;
                    cell.imageTextBackView.isHidden = false;
                }
                else {
                    //cell.bottomView.isHidden = true //ravinder
                    cell.imageBackView.isHidden = true
                    cell.videoBackView.isHidden = true;
                    cell.imageTextBackView.isHidden = true;
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0{
            return 178
        }else if indexPath.section == 1{
            return 105
        }else if indexPath.section == 2{
            
            if let userFile = self.detailsDict.value(forKey: "userFile") as? String, let userStatus = self.detailsDict.value(forKey: "userStatus") as? String {
                if userFile.count > 0 && userStatus.count > 0{
                    
                    return 320 + 50 // ranjeet
                    
                }else if userFile.count > 0 {
                    
                    return 190 + 68  + 50 // ranjeet
                    
                }else if userStatus.count > 0{
                    return 60 + 68 //+ 50 // ranjeet
                }else{
                    return 65 + 50 // ranjeet
                }
                
                
            }else{
                return 65 + 50 // ranjeet //0+50
            }
            
        }else if indexPath.section == 3{
            var dict = NSDictionary()
            dict = networkUpdateArray[indexPath.row] as! NSDictionary
            
            if let userFile = dict.value(forKey: "userFile") as? String, let userStatus = dict.value(forKey: "userStatus") as? String {
                if userFile.count > 0 && userStatus.count > 0{
                    
                    return 320 + 50 // ranjeet
                    
                }else if userFile.count > 0 {
                    
                    return 190 + 68 + 50 // ranjeet
                    
                }else if userStatus.count > 0{
                    return 60 + 68 //+ 50 // ranjeet
                    
                }else{
                    return 65 + 50 // ranjeet
                }
                
                
            }else{
                return 65 + 50 // ranjeet
            }
            
        }else {
            var dict = NSDictionary()
            dict = shareUpdateArray[indexPath.row] as! NSDictionary
            
            if let userFile = dict.value(forKey: "globalFile") as? String, let userStatus = dict.value(forKey: "globalStatus") as? String {
                if userFile.count > 0 && userStatus.count > 0{
                    
                    return 320 + 50 // ranjeet
                    
                }else if userFile.count > 0 {
                    
                    return 190 + 68 + 50 // ranjeet
                    
                }else if userStatus.count > 0{
                    return 60 + 68 //+ 50 // ranjeet
                    
                }else{
                    return 65 + 50 // ranjeet
                }
                
                
            }else{
                return 65 + 50 // ranjeet
            }
            
        }
    }
    
   func validatesendfriendRequest(emailId:String) {
        //self.activityindicator.startAnimating();
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        let urlToRequest = WEBSERVICE_URL+"sendfriendRequest.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+UserId+"&"+"emailId="+emailId
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            if let data = data {
                DispatchQueue.main.async { // Correct
                    
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("***** \(String(describing: dataString))") //JSONSerialization
                    //self.activityindicator.stopAnimating();
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    DispatchQueue.main.async { // Correct
                        
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }else{
                    DispatchQueue.main.async { // Correct
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }
    
    func unInvitefriendRequest(userID2:String) {
        //self.activityindicator.startAnimating();
        let UserId = UserDefaults.standard.value(forKey: "userId") as! String
        let urlToRequest = WEBSERVICE_URL+"unInvite.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+UserId+"&"+"userId2="+userID2
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            if let data = data {
                DispatchQueue.main.async { // Correct
                    
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("***** \(String(describing: dataString))") //JSONSerialization
                    //self.activityindicator.stopAnimating();
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    DispatchQueue.main.async { // Correct
                        
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }else{
                    DispatchQueue.main.async { // Correct
                        let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }
    
    
    
    //Invite
    @objc func selectAction(sender: UIButton) -> Void {
        
        
        print(UserDefaults.standard.string(forKey: "firstName")!)
        print(UserDefaults.standard.string(forKey: "lastName")!)
        print(UserDefaults.standard.string(forKey: "userId")!)
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let cell = self.tableView.cellForRow(at: indexPath!) as! MyPostTVC
        var dict = NSDictionary()
        dict = shareUpdateArray[(indexPath?.row)!] as! NSDictionary
        
        if cell.inviteBtn.titleLabel?.text! == "UnInvite friend"{
            self.unInvitefriendRequest(userID2:dict.object(forKey: "userId") as! String)
        }
        else{
            if let userName = dict.value(forKey: "userName") as? String {
                print(userName)
            }
            if let userId = dict.value(forKey: "userId") as? String {
                print(userId)
            }
            if let globalFile = dict.value(forKey: "globalFile") as? String {
                print(globalFile)
            }
            if let emailId = dict.value(forKey: "emailId") as? String {
                print(emailId)
                validatesendfriendRequest(emailId: emailId)
            }
        }
   
    }
    
   
   
    @objc func callController(){
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "NewPostViewController") as! NewPostViewController
        desCV.from = "1"
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
   
    
    func getMyProfileDetailData() -> Void {
        
        let postData = NSMutableData(data: "userId=\(String(describing: UserDefaults.standard.string(forKey: "userId")!))".data(using: String.Encoding.utf8)!)
        
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "showUserStatus.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "MyWorld", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        // Do whatever you want with inputTextField?.text
                        
                    })
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                })
                
            }else{
                
                print(data);
                
                if data .value(forKey: "responseCode") as! String == "200"{
                    DispatchQueue.main.async(execute: {
                        
                        self.detailsDict = data
                        
                        let value: AnyObject? = self.detailsDict.value(forKey: "statusList") as AnyObject
                        
                        if value is NSString {
                            print("It's a string")
                            
                        } else if value is NSArray {
                            print("It's an NSArray")
                            
                            self.networkUpdateArray = value as! NSArray
                            
                        }

                        self.tableView.reloadData()
                        self.getUpdatesDetailData()
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        let alertController = UIAlertController(title: "Haultips", message: data .value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            // Do whatever you want with inputTextField?.text
                            
                        })
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    })
                }
                
            }
            
        })
    }
    
    func getUpdatesDetailData() -> Void {
        
        let postData = NSMutableData(data: "userId=\(String(describing: UserDefaults.standard.string(forKey: "userId")!))".data(using: String.Encoding.utf8)!)
        
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "showGlobalStatus.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "MyWorld", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        // Do whatever you want with inputTextField?.text
                        
                    })
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                })
                
            }else{
                
                print(data);
                
                if data .value(forKey: "responseCode") as! String == "200"{
                    DispatchQueue.main.async(execute: {
                        
                        let value: AnyObject? = data.value(forKey: "statusList") as AnyObject
                        
                        if value is NSString {
                            print("It's a string")
                            
                        } else if value is NSArray {
                            print("It's an NSArray")
                            self.shareUpdateArray = value as! NSArray
                            
                        }
                        self.tableView.reloadData()
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        let alertController = UIAlertController(title: "MyWorld", message: data .value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            // Do whatever you want with inputTextField?.text
                            
                        })
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    })
                }
                
            }
            
        })
    }
    
    
    @objc func takePhotoAction(_ sender: UIButton) {
        if sender.tag == 1 {
            isProfileUpdate = true
        }else{
             isProfileUpdate = false
        }
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
        let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    //MARK: - Actions
    //get a photo from the library. We present as a popover on iPad, and fullscreen on smaller devices.
    @IBAction func photoFromLibrary() {
        picker.allowsEditing = false //2
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary //3
        picker.modalPresentationStyle = .popover
        picker.delegate = self
        present(picker,animated: true,completion: nil)//4
    }
    
    //take a picture, check if we have a camera first.
    @IBAction func shootPhoto() {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        }
        else {
            noCamera()
        }
    }
    
    func pkcCropImage(_ image: UIImage?, originalImage: UIImage?) {
        let chosenImage = image
        let index = IndexPath.init(row: 0, section: 0)
        let cell = tableView.cellForRow(at:index) as! MyPostTVC
        if isProfileUpdate {
            cell.profileImage.contentMode = .scaleAspectFill //3
            cell.profileImage.image = chosenImage
            imageData = (cell.profileImage.image?.lowestQualityJPEGNSData)!
            
        }else{
            cell.profileBackGroundImage.contentMode = .scaleAspectFill //3
            cell.profileBackGroundImage.image = chosenImage
            imageData = (cell.profileBackGroundImage.image?.lowestQualityJPEGNSData)!
        }
        SendDataToServer()
    }
    
    //If crop is canceled
    func pkcCropCancel(_ viewController: PKCCropViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
    
    //Successful crop
    func pkcCropComplete(_ viewController: PKCCropViewController) {
        if viewController.tag == 0{
            viewController.navigationController?.popViewController(animated: true)
        }else{
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            return
        }
        PKCCropHelper.shared.isNavigationBarShow = true
        let cropVC = PKCCropViewController(image, tag: 1)
        cropVC.delegate = self
        picker.pushViewController(cropVC, animated: true)
       /* let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        let index = IndexPath.init(row: 0, section: 0)
        let cell = tableView.cellForRow(at:index) as! MyPostTVC
        if isProfileUpdate {
            cell.profileImage.contentMode = .scaleAspectFill //3
            cell.profileImage.image = chosenImage
            imageData = (cell.profileImage.image?.lowestQualityJPEGNSData)!
        }
        else{
            cell.profileBackGroundImage.contentMode = .scaleAspectFill //3
            cell.profileBackGroundImage.image = chosenImage
            imageData = (cell.profileBackGroundImage.image?.lowestQualityJPEGNSData)!
        }
        SendDataToServer()
        dismiss(animated:true, completion: nil) */
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.isKeyboardDismiss = true
        self.view.endEditing(true)
        return true
    }
   
    
    @objc func alertClose(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func SendDataToServer() -> Void {
        let param = [
            "userId" : UserDefaults.standard.string(forKey: "userId")]
            
        SVProgressHUD.show(withStatus: "Loading")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if self.imageData.length == 0{
                
            }else{
                if self.isProfileUpdate {

                multipartFormData.append(self.imageData as Data, withName: "image1", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }else{
                    multipartFormData.append(self.imageData as Data, withName: "image2", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")

                }
            }
            for (key, value) in param {
                
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key )
                
            }
            
        }, to: WEBSERVICE_URL + "updateuserImage.php")
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
                        let alertController = UIAlertController(title: "Image", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                        SVProgressHUD.dismiss()
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            // Do whatever you want with inputTextField?.text
                            self.viewWillAppear(true)
                        })
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else{
                        DispatchQueue.main.async(execute: {
                            let alertController = UIAlertController(title: "Image", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                            SVProgressHUD.dismiss()
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                // Do whatever you want with inputTextField?.text
                                self.navigationController?.popViewController(animated:true)
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





extension UIImage
{
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! as NSData }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! as NSData }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! as NSData}
    var lowestQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.0)! as NSData }

}



