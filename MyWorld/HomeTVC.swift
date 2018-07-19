//
//  HomeTVC.swift
//  MyWorld
//
//  Created by Shankar Kumar on 15/02/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
protocol RecentChatProtocol {
    func openRecentChat(userid:String,email:String)
    func openNearBuyItem(productid:String,userName:String)
    func openBuyPage()
}



class HomeTVC: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var onlineCollectionView: UICollectionView!
    @IBOutlet weak var nearByCollectionView: UICollectionView!
    @IBOutlet weak var nearByView1: UIView!
    @IBOutlet weak var nearByView: UIView!

    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var imageViewThree: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!

    @IBOutlet weak var updateStatusBtn: UIButton!
    @IBOutlet weak var myPageBtn: UIButton!
    
    @IBOutlet weak var onlineBtn: UIButton!
    
    @IBOutlet weak var recentBtn: UIButton!

    var delegate:RecentChatProtocol?
    
    var brandList = [FutureBrand]()

    var productUser2 = [SellProductList]()
    var recentList = [RecentChatList]()
    var friendList = [OnlineFriends]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func updateProduct(brandListdata:[FutureBrand]) -> Void {
        brandList = brandListdata
        productCollectionView.reloadData()

    }
    
    
    func updateNearBy(productUserData:[SellProductList]) -> Void {
        productUser2 = productUserData
        nearByCollectionView.reloadData()
        
    }
    
    
    func updateChat(recentListData:[RecentChatList]) -> Void {
        recentList = recentListData
        chatCollectionView.reloadData()
        
    }
    
    
    func updateOnline(friendListData:[OnlineFriends]) -> Void {
        friendList = friendListData
        onlineCollectionView.reloadData()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView ==  productCollectionView{
            return brandList.count
        }else if collectionView == chatCollectionView {
            return recentList.count
        }else if collectionView == onlineCollectionView {
            return friendList.count
        }else{
            return productUser2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HomeCVC?
            
        if collectionView ==  productCollectionView{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as? HomeCVC
            cell?.productNameLbl.text! = brandList[indexPath.row].brandName
            if let imageURL = URL(string:brandList[indexPath.row].brandImage){
                cell?.productImage.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
        }
        else if collectionView == chatCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chat", for: indexPath) as? HomeCVC
            cell?.chatUserNameLbl.text! = recentList[indexPath.row].firstName
            cell?.chatProfileImage.layer.cornerRadius = (cell?.chatProfileImage.frame.size.width)! / 2;
            cell?.chatProfileImage.clipsToBounds = true;
            
            if recentList[indexPath.row].profileImage.hasPrefix("graph"){
                if let imageURL = URL(string: "https://"+recentList[indexPath.row].profileImage){
                    cell?.chatProfileImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                }
            }
            else if (recentList[indexPath.row].profileImage.hasSuffix(".jpg") || recentList[indexPath.row].profileImage.hasSuffix(".jpeg")){
                if let imageURL = URL(string: recentList[indexPath.row].profileImage){
                    cell?.chatProfileImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                }
            }
            else{
                /*if let imageURL = URL(string: "http://18.221.196.77/myworldapi/upload/defaultuserprofile.png"){
                    cell?.chatProfileImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                }*/
                 cell?.chatProfileImage.sd_setImage(with: URL(string: recentList[indexPath.row].profileImage), placeholderImage: UIImage(named: "ic_profile"))
            }
        }
        else if collectionView == onlineCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "online", for: indexPath) as? HomeCVC
            cell?.onlineNameLbl.text! = friendList[indexPath.row].firstName
            cell?.onlineProfileImage.layer.cornerRadius = (cell?.onlineProfileImage.frame.size.width)! / 2;
            cell?.onlineProfileImage.clipsToBounds = true;
            
            if (friendList[indexPath.row].profileImage.hasPrefix("graph")){
                
                if let imageURL = URL(string: "https://"+friendList[indexPath.row].profileImage){
                    cell?.onlineProfileImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                }
            }
            else if (friendList[indexPath.row].profileImage.hasSuffix(".jpg") || friendList[indexPath.row].profileImage.hasSuffix(".jpeg")) {
                if let imageURL = URL(string: friendList[indexPath.row].profileImage){
                    cell?.onlineProfileImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                }
            }
            else{
                /*if let imageURL = URL(string: "http://18.221.196.77/myworldapi/upload/defaultuserprofile.png"){
                    cell?.onlineProfileImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(named: "ic_profile"))
                }*/
                 cell?.onlineProfileImage.sd_setImage(with: URL(string: friendList[indexPath.row].profileImage), placeholderImage: UIImage(named: "ic_profile"))
            }
        }
        else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "near", for: indexPath) as? HomeCVC
            cell?.nearNameLbl.text! = productUser2[indexPath.row].productName
            
            if let imageURL = URL(string:productUser2[indexPath.row].productImage1){
                cell?.nearProfileImage.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
            }
        }
        cell?.contentView.layer.cornerRadius = 2.0
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        cell?.contentView.layer.masksToBounds = true
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView ==  productCollectionView{
            return CGSize(width: 140, height: 140)
        }else if collectionView == chatCollectionView {
            return CGSize(width: 76, height: 115)
        }else if collectionView == onlineCollectionView {
            return CGSize(width: 85, height: 95)
        }else{
            return CGSize(width: 80, height: 90)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 1, 1, 1) //top, left, bottom, right
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == chatCollectionView {
            print("Recent Chat Clicked\n")
            delegate?.openRecentChat(userid:recentList[indexPath.row].userId, email: recentList[indexPath.row].emailId)
        }
        else if collectionView == nearByCollectionView {
            print("Nearby Product Clicked\n")
            print(String(productUser2[indexPath.row].productId))
            print(String(productUser2[indexPath.row].userName))
            delegate?.openNearBuyItem(productid:productUser2[indexPath.row].productId, userName: productUser2[indexPath.row].userName)
        }
        else if collectionView == productCollectionView {
            print("Product Fetured Product Clicked\n")
            delegate?.openBuyPage()
        }
        
        
    }
    
}
