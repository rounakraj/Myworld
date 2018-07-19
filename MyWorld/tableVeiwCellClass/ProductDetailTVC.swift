//
//  ProductDetailTVC.swift
//  MyWorld
//
//  Created by Shankar Kumar on 01/02/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class ProductDetailTVC: UITableViewCell ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapAddress: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblUploadbyName: UILabel!
    @IBOutlet weak var lblProductSubName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnQty: UIButton!
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var txtQty: UITextField!

    @IBOutlet weak var lblProductSubCatName: UILabel!
    @IBOutlet weak var lblInrPrice: UILabel!
    @IBOutlet weak var lblAddPosthours: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var txtDiscription: UITextView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var middleContainerView: UIView!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var bottomViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnTwiter: UIButton!

    @IBOutlet weak var btnWhatsApp: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [String]()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let border = CALayer()
//        border.backgroundColor = UIColor.lightGray.cgColor
//        border.frame = CGRect(x: 0, y: self.frame.size.height - self.txtDiscription.frame.size.width, width: self.frame.size.width, height: self.txtDiscription.frame.size.width)
//
//        self.txtDiscription.layer.addSublayer(border)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCollection(array: [String])  {
        images = array
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductDetailCVC
        
        //self.pageControl.currentPage = Int(indexPath.row);
        if let imageURL = URL(string: images[indexPath.row]){
            cell.imageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
        }
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        return cell
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
        //return CGSize(width: self.frame.size.width, height: self.collectionView.frame.size.height)
        return CGSize(width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(1, 1, 1, 1) //top, left, bottom, right
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        print(visibleIndexPath)
        pageControl.currentPage = visibleIndexPath.row
    }
}
