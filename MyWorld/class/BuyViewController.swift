//
//  BuyViewController.swift
//  MyWorld
//
//  Created by MyWorld on 13/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD

class BuyViewController: UIViewController {
    @IBOutlet weak var myView: UIView!

    @IBOutlet weak var lblBudge: UILabel!

    @IBAction func btnCart(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "SearchDetailItemVC") as! SearchDetailItemVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func HomeAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "CartListViewController") as! CartListViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    
    @IBAction func backPress(_ sender: Any) {
        
        self.navigationController?.popViewController(animated:true)
    }
    
    
    var tabs = [
        ViewPagerTab(title: "New", image: UIImage(named: "house")),
        ViewPagerTab(title: "Popular", image: UIImage(named: "popular")),
        ViewPagerTab(title: "Deals", image: UIImage(named: "deals")),
        ViewPagerTab(title: "Trending", image: UIImage(named: "sell_white")),
       ]

    var cartList = [CartList]()

    private var newproduct = [NewProductList]()
    private var popularList = [PopularList]()
    private var dealsListServer = [DealsList]()
    private var dealsListsUser = [DealsList]()
    private var trendingList = [TrendingList]()
    var globaleArrays = [GlobaleArray]()

    
    var viewPager:ViewPagerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblBudge.isHidden=true

        let options = ViewPagerOptions(viewPagerWithFrame:  CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        options.tabType = ViewPagerTabType.imageWithText
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont.systemFont(ofSize: 16)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        options.isEachTabEvenlyDistributed = true
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.view.frame =  CGRect(x: 0, y: 0 , width: myView.frame.size.width, height: self.myView.frame.size.height)
        self.addChildViewController(viewPager)
        self.myView.addSubview(viewPager.view)
        viewPager.didMove(toParentViewController: self)
        
        lblBudge.clipsToBounds = true
        lblBudge.layer.cornerRadius = lblBudge.frame.size.height/2
        lblBudge.layer.borderWidth = 0.8
        lblBudge.layer.borderColor = UIColor.clear.cgColor
        validateShowCart(UserId: UserDefaults.standard.value(forKey: "userId") as! String)

    }
    
    
    func validateShowCart(UserId:String) {
        let userId = UserId
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"showCart.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="userId="+userId
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
                
                //let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    let decoder = JSONDecoder()
                    let  downloadcartList = try decoder.decode(CartLists.self, from: data!)
                    self.cartList = downloadcartList.cartList
                    
                    DispatchQueue.main.async { // Correct
                        
                        if self.cartList.count > 0{
                            
                            self.lblBudge.text = String(self.cartList.count)
                            self.lblBudge.isHidden=false
                        }else{
                            self.lblBudge.isHidden=true
                        }
                        
                    }
                }
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }

}


extension BuyViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BuyItemListViewController") as! BuyItemListViewController
        //vc.itemText = "\(tabs[position].title!)"
        if position==0{
           
            vc.itemText = "0"
            vc.newproduct = newproduct
        }else if position==1{
            
            
            vc.itemText = "1"
            vc.popularList = popularList
        
        }else if position==2{
            
            vc.itemText = "2"
            vc.dealsListServer = dealsListServer
        
        }else if position==3{
            
            vc.itemText = "3"
            vc.trendingList = trendingList
        }
        
        print("page count\(position)")
        return vc
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension BuyViewController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        //print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        //print("Moved to page \(index)")
    }
    
    
  

}

