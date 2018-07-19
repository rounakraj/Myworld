//
//  ProductImagePageViewController.swift
//  MyWorld
//
//  Created by Bhupesh Kathuria on 17/12/17.
//  Copyright © 2017 Bhupesh Kathuria. All rights reserved.
//

import UIKit

class ProductImagePageViewController: UIPageViewController {
    
    //var images: [UIImage]?
    var image: [String]?
    
    var getProductId = String()
    var getuserName = String()
    
     private var productlist = [ProductDetailsList]()
    //weak var pageViewControllerDelegate: ProductImagePageViewControllerDelegate?
    
    struct  Storyboard {
        static let ProductDetaiImageViewController = "ProductDetaiImageViewController"
    }
    
    lazy var controllers: [UIViewController] = {
        
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        
        var controllers =  [UIViewController]()
        
        if let image = self.image {
            for image in image {
                
                let vc =  storyboard.instantiateViewController(withIdentifier: Storyboard.ProductDetaiImageViewController)
                controllers.append(vc)
            }
        }
        
        return controllers
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        automaticallyAdjustsScrollViewInsets = false
        dataSource = self
        delegate = self
        let productId: String = getProductId
        let userName: String = getuserName
        
       validateDetails(productId: productId,userName: userName)
    }
    

    func validateDetails(productId:String,userName:String) {
        //self.activityindicator.startAnimating();
        let urlToRequest = WEBSERVICE_URL+"getproductDetail.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="productId="+productId+"&"+"userName="+userName
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response ProductDetails\(String(describing: Data))") //JSONSerialization'
                
                let decoder = JSONDecoder()
                let  downloadproductlist = try decoder.decode(ProductDetailsLists.self, from: data!)
                self.productlist = downloadproductlist.productlist
                
                print(self.productlist[0].productImage1)
                
                let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                
                if responseCode==checkcode{
                    DispatchQueue.main.async { // Correct
                        
                        self.image?.append(self.productlist[0].productImage1)
                        self.image?.append(self.productlist[0].productImage2)
                        self.image?.append(self.productlist[0].productImage3)
                        
                        self.turnToPage(index: 0)
                    }
                }else{
                    
                    let alertController = UIAlertController(title: "My World", message: messageFromServer, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }
    
    
    
    
    
    
    func turnToPage(index: Int)
    {
        let controller = controllers[index]
        var direction = UIPageViewControllerNavigationDirection.forward
        
        if let currentVC = viewControllers?.first {
            let currentIndex = controllers.index(of: currentVC)!
            if currentIndex > index {
                direction = .reverse
            }
        }
        
        self.configureDisplaying(viewController: controller)
        
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func configureDisplaying(viewController: UIViewController)
    {
        for (index, vc) in controllers.enumerated() {
            if viewController === vc {
                if let shoeImageVC = viewController as? ProductDetaiImageViewController {
                    shoeImageVC.image = self.image?[index]
                    
                      //self.pageViewControllerDelegate?.turnPageController(to: index)
                }
            }
        }
    }

}

//MarkL: UIPageViewcontroller

extension ProductImagePageViewController : UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = controllers.index(of: viewController){
            
            if index > 0{
                
                return controllers[index-1]
            }
        }
        
        return controllers.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        if let index = controllers.index(of: viewController){
            
            if index < controllers.count - 1{
                
                return controllers[index + 1]
            }
        }
        
        return controllers.first
    }
    
}


extension ProductImagePageViewController : UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        self.configureDisplaying(viewController: pendingViewControllers.first as! ProductDetaiImageViewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if !completed {
            self.configureDisplaying(viewController: previousViewControllers.first as! ProductDetaiImageViewController)
        }
    }
}









