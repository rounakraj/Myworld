//
//  OrderPlaceViewController.swift
//  MyWorld
//
//  Created by MyWorld on 05/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class OrderPlaceViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableviewList: UITableView!
    @IBOutlet weak var callectionView: UICollectionView!
    
    
    var similarList = [SimilarList]()
    var orderList = [OrderList]()
    @IBAction func btnBackPress(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableviewList.reloadData()
        callectionView.reloadData()
        
        tableviewList.dataSource = self
        tableviewList.delegate = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return similarList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarTableViewCell")as? SimilarTableViewCell else{ return UITableViewCell ()}
        
        cell.lblSimilarProducatName.text = similarList[indexPath.row].productName
        cell.lblSimilarPrice.text = "Price"+similarList[indexPath.row].productPrice
        cell.lblSimilarQuntiy.text = "Special Price "+similarList[indexPath.row].ProductsplPrice
        cell.lblSimilarQuntity.text = similarList[indexPath.row].userName
        
        if let imageURL = URL(string: similarList[indexPath.row].productImage1){
            cell.imgSimlar.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "bg_drop-shadow_320x430"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180;
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderListCollectionViewCell", for: indexPath) as! OrderListCollectionViewCell
        
        cell.lblOrderProducatName.text! = orderList[indexPath.row].productName
        cell.lblOrderINRName.text! = orderList[indexPath.row].productPrice
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        if let imageURL = URL(string: orderList[indexPath.row].productImage1){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                
                if let data = data{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgeOrderImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ProducatViewController") as! ProducatViewController
        desCV.getProductId = orderList[indexPath.row].productId
        desCV.getuserName = orderList[indexPath.row].productName//userName
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
   
    @IBAction func viewOrderAction(_ sender: Any) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as! OrderHistoryViewController
        self.navigationController?.pushViewController(desCV, animated: true)
    }
}
