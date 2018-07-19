//
//  SplashViewController.swift
//  MyWorld
//
//  Created by MyWorld on 04/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var imaImageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imaImageview.loadGif(name: "splash_background")
        perform(#selector(showNavigation), with:nil, afterDelay: 5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showNavigation()
    {
        performSegue(withIdentifier:"showNavigation", sender:self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
