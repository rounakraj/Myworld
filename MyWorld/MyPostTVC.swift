//
//  MyPostTVC.swift
//  MyWorld
//
//  Created by Shankar Kumar on 07/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class MyPostTVC: UITableViewCell {

    @IBOutlet weak var profileBackGroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfileImageBtn: UIButton!
    @IBOutlet weak var changeBackBtn: UIButton!
    @IBOutlet weak var newPostBtn: UIButton!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var updatesProfileImage: UIImageView!
    @IBOutlet weak var updateUserName: UILabel!
    @IBOutlet weak var updateDate: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var shareBtn: UIButton!

    @IBOutlet weak var videoBackView: UIView!
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var imageTextBackView: UIView!
    @IBOutlet weak var imageTextVideoBackView: UIView!

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageTextView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!

    @IBOutlet weak var shareContentBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
