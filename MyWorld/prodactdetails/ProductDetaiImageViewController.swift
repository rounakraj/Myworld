//
//  ProductDetaiImageViewController.swift
//  MyWorld
//
//  Created by Bhupesh Kathuria on 17/12/17.
//  Copyright © 2017 Bhupesh Kathuria. All rights reserved.
//

import UIKit

class ProductDetaiImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: String?{
        didSet {
            //self.imageView?.image = image
            
            if let imageURL = URL(string: image!){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    
                    if let data = data{
                        let images = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.imageView?.image = images
                        }
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageURL = URL(string: image!){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                
                if let data = data{
                    let images = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imageView?.image = images
                    }
                }
            }
        }
    }

       // self.imageView.image = image

}
