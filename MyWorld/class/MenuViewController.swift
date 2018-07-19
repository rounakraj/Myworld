//
//  MenuViewController.swift
//  MyWorld
//
//  Created by MyWorld on 05/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

protocol MenuDelegate {
    func didSelecte(index:NSInteger)
}
class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var lblEmailId: UILabel!
    var delegate:MenuDelegate?
    
    @IBOutlet weak var imageProfile: UIImageView!
    var menuNameArr:Array=[String]()
    var iconeImage:Array=[UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.isHidden = true

        menuNameArr=["Post Add","Home","My Account","Refer & Earn","Friend List","Order History","Address Book","Browse Category","Terms & Conditions","Contact Us","Logout"]
        
        iconeImage=[UIImage(named:"postad")!,UIImage(named:"home")!,UIImage(named:"myaccount")!,UIImage(named:"referandearn")!,UIImage(named: "frindlist")!,UIImage(named:"orderhistory")!,UIImage(named: "address")!,UIImage(named:"browsecategory")!,UIImage(named:"termsandcondition")!,UIImage(named:"contacts")!,UIImage(named:"logout")!]
     
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageProfile.isUserInteractionEnabled = true
        imageProfile.addGestureRecognizer(tapGestureRecognizer)

        imageProfile.layer.cornerRadius = imageProfile.frame.size.width / 2;
        imageProfile.clipsToBounds = true;
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblEmailId.text = UserDefaults.standard.value(forKey: "EmailId") as? String
        let profileImg = UserDefaults.standard.value(forKey: "profileImage") as! String
        if profileImg.hasPrefix("graph"){
            print("Facebook")
            if profileImg.hasPrefix("https"){
                print("Facebook without http")
                if let imageURL = URL(string: profileImg){
                    self.imageProfile.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "ic_profile"))
                }
            }
            else{
                print("Facebook without http")
                if let imageURL = URL(string: "https://"+profileImg){
                    self.imageProfile.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                }
            }
        }
        else if (profileImg.hasSuffix("jpg") || profileImg.hasSuffix("jpeg")){
            if let imageURL = URL(string: profileImg){
                self.imageProfile.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "ic_profile"))
            }
        }
        else{
            if let imageURL = URL(string: "http://18.221.196.77/myworldapi/upload/defaultuserprofile.png"){
                self.imageProfile.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        
       
        let revelViewController: SWRevealViewController = self.revealViewController()
        
        delegate?.didSelecte(index:15)
        revelViewController.revealToggle(animated: true)

        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell")as!MenuTableViewCell
        cell.imgIcon.image=iconeImage[indexPath.row]
        cell.lblMenuName.text!=menuNameArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revelViewController: SWRevealViewController = self.revealViewController()
        
        delegate?.didSelecte(index: indexPath.row)
        let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        print(cell.lblMenuName.text!)
        revelViewController.revealToggle(animated: true)

        
    }
    
    

}
