//
//  PostView.swift
//  MyWorld
//
//  Created by Shankar Kumar on 11/03/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class PostView: UIView {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var mixView: UIView!
    @IBOutlet weak var textView: UIView!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    @IBOutlet weak var postTextMixView: UITextView!
    @IBOutlet weak var postImageMixView: UIImageView!


    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.borderWidth = 0.8
        userImage.layer.borderColor = UIColor.white.cgColor
    }
 

}
