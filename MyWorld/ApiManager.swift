//
//  ApiManager.swift
//  Haultips
//
//  Created by Alivenet Solution on 14/06/17.
//  Copyright © 2017 Alivenet Solution. All rights reserved.
//

import UIKit
import SystemConfiguration
import SVProgressHUD

class ApiManager: NSObject {
    
    class func getData(paramValue : NSMutableData,isactivity:Bool,apiName:String,uiView:UIView, withCompletionHandler:@escaping (_ result:NSDictionary, Error?) -> Void)
    {
        if Reachability.shared.isConnectedToNetwork(){
            SVProgressHUD.show(withStatus: "Loading")

            
            let headers = [
                "content-type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache",
                ]
            
            let request = NSMutableURLRequest(url: NSURL(string:WEBSERVICE_URL+apiName)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = paramValue as Data
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error ?? "error")
                    let dataArray = NSDictionary()
                    if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                        withCompletionHandler(dataArray, error)
                    }else{
                        withCompletionHandler(dataArray, error as NSError?)
                        SVProgressHUD.dismiss()

                    }
                    
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse ?? "response")
                    let statusCode = httpResponse?.statusCode
                    if  apiName == "showUserStatus.php"{
                    }
                    else{
                        SVProgressHUD.dismiss()
                    }
                    
                    if statusCode == 200 {
                        let dataArray = try! JSONSerialization.jsonObject(with: data!, options: [.allowFragments] ) as! NSDictionary
                        withCompletionHandler(dataArray, nil)
                    }else {
                        let myArrayOfDict: NSDictionary =
                            ["responseCode": "0", "responseMessage": "Please try Again"]
                        
                        withCompletionHandler(myArrayOfDict, error)
                    }
                }
            })
            
            dataTask.resume()
        }else{
            SVProgressHUD.showError(withStatus: "Make sure your device is connected to the internet.")
        }
        
    }
}



final class Reachability {
    
    private init () {}
    class var shared: Reachability {
        struct Static {
            static let instance: Reachability = Reachability()
        }
        return Static.instance
    }
    
    func isConnectedToNetwork() -> Bool {
        guard let flags = getFlags() else { return false }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    private func getFlags() -> SCNetworkReachabilityFlags? {
        guard let reachability = ipv4Reachability() ?? ipv6Reachability() else {
            return nil
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return nil
        }
        return flags
    }
    
    private func ipv6Reachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in6()
        zeroAddress.sin6_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin6_family = sa_family_t(AF_INET6)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    private func ipv4Reachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
}


