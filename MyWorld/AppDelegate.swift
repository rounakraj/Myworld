//
//  AppDelegate.swift
//  MyWorld
//
//  Created by MyWorld on 04/12/17.
//  Copyright © 2017 MyWorld. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import SVProgressHUD
import UserNotifications
import FacebookCore
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate,SWRevealViewControllerDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var navigationController = UINavigationController()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications()
        IQKeyboardManager.sharedManager().enable = true
        GIDSignIn.sharedInstance().clientID = "586287600666-uucfn6orpp8pugmf6q21b8fkmjv7t61t.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        SVProgressHUD.setMinimumSize(CGSize.init(width: 100, height: 100))
        SVProgressHUD.setBackgroundColor(.lightGray)
    UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        return true
    }
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       completionHandler(UIBackgroundFetchResult.newData)
    }
 
    //MARK: - Slider View
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    // [START openurl]
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    // [END openurl]
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                                sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        let facebookDidHandle = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        
        return googleDidHandle || facebookDidHandle
      
    }
    
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let profileImage = user.profile.hasImage
            let image = user.profile.imageURL(withDimension: 9999)
            let finalImage = image?.absoluteString
            registerUserSocialMedia(fullName:fullName!,emailId:email!,image:finalImage!,deviceId:"123456")
            let userDefaults = UserDefaults.standard
            userDefaults.set(finalImage, forKey: "profileImage")
            userDefaults.synchronize()
            print(profileImage)
            // [START_EXCLUDE]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName ?? "")"])
            // [END_EXCLUDE]
        }
    }
    // [END signin_handler]
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    // [END disconnect_handler]
    
    
    func registerUserSocialMedia(fullName:String,emailId:String,image:String,deviceId:String) {
        let urlToRequest = WEBSERVICE_URL+"registerUser.php"
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString="device=ios"+"&fullName="+fullName+"&"+"emailId="+emailId+"&"+"image="+image+"&"+"deviceId=" + ( UserDefaults.standard.string(forKey: "deviceToken") ?? "")
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
                    
                    
                }
            }
            
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print("*****Response \(String(describing: Data))") //JSONSerialization
                
                
                //let  messageFromServer = Data["responseMessage"] as? String
                let responseCode=Data["responseCode"] as? String
                let checkcode="200"
                if responseCode==checkcode{
                    
                    DispatchQueue.main.async { // Correct
                        
                        let EmailId=Data["emailId"] as? String
                        let userId=Data["userId"] as? String
                        let firstName=Data["firstName"] as? String
                        let lastName=Data["lastName"] as? String
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(EmailId, forKey: "EmailId")
                        userDefaults.set(userId, forKey: "userId")
                        userDefaults.set(firstName, forKey: "firstName")
                        userDefaults.set(lastName, forKey: "lastName")
                        userDefaults.synchronize()
                        
                       self.openDashBoaerdController()

                    }
                }
                
            } catch let error as NSError {
                print(error)
                
            }
            
        }
        
        task.resume()
    }
    
    func openDashBoaerdController() -> Void {
        var viewController: SWRevealViewController = SWRevealViewController()
        let Dashboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Dashboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let menuvc = Dashboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuvc.delegate = vc
        self.navigationController = UINavigationController(rootViewController: vc)
        let navigationControllermenuvc = UINavigationController(rootViewController: menuvc)
        let revealController = SWRevealViewController.init(rearViewController: navigationControllermenuvc, frontViewController: self.navigationController)
        revealController?.delegate = self
        viewController = revealController!
        AppDelegate.getAppDelegate().window = UIWindow(frame: UIScreen.main.bounds)
        AppDelegate.getAppDelegate().window?.rootViewController = viewController
        AppDelegate.getAppDelegate().window?.backgroundColor = UIColor.white
        AppDelegate.getAppDelegate().window?.makeKeyAndVisible()
        let holdingView = AppDelegate.getAppDelegate().window?.rootViewController!.view!
        holdingView?.addSubview(BootomBar.shared)
        
    }

    func jumpToViewController(type:String,userId:String,userName:String,email:String){
        switch type {
        case "user":
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            controller.userId2 = userId
            controller.emailID = email
            self.navigationController.pushViewController(controller, animated: true)
            break
        case "admin":
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main1", bundle:nil)
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "AdminChatVC") as! AdminChatVC
            self.navigationController.pushViewController(controller, animated: true)
            break
        case "accept":
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController") as! FriendsListViewController
            desCV.userId =  UserDefaults.standard.object(forKey:"userId") as! String//userId
            self.navigationController.pushViewController(desCV, animated: true)
            break
        case "request":
            let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let desCV = MainStoryboard.instantiateViewController(withIdentifier: "FriendRequestViewController") as! FriendRequestViewController
            desCV.userId = UserDefaults.standard.object(forKey:"userId") as! String//userId
            self.navigationController.pushViewController(desCV, animated: true)
            break
        default:
            break
        }
    }
    

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async(execute: {
            UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }
    
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceToken")
    NotificationManager.sharedController().client.registerPushNotificationData(deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        if aps["content-available"] as? Int == 1 {
            let Notification_Msg =  (userInfo["aps"] as! NSDictionary).object(forKey: "alert") as! String
            let Notification_Type = (userInfo["aps"] as! NSDictionary).object(forKey: "title") as! String
            let User_Id = (userInfo["aps"] as! NSDictionary).object(forKey: "userId2") as! String
            let User_Name = (userInfo["aps"] as! NSDictionary).object(forKey: "userName") as! String
            let Email_ID = (userInfo["aps"] as! NSDictionary).object(forKey: "emailId") as! String
            let alertController = UIAlertController(title: "MyWorld", message: Notification_Msg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.jumpToViewController(type:Notification_Type,userId:User_Id,userName:User_Name,email:Email_ID)
            })
            alertController.addAction(ok)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        else{
            NotificationManager.sharedController().push.application(application, didReceiveRemoteNotification: userInfo)
        }
        //debugPrint(aps)
  
    }
    
}



