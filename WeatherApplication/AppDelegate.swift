//
//  AppDelegate.swift
//  WeatherApplication
//
//  Created by Mac on 06/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    let userDefault = UserDefaults.standard
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.frame = UIScreen.main.bounds
        
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
    BarButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        
        if userDefault.bool(forKey: SIGNIN) == true{
            //User already signin
           setUpHomeViewController()
            
        } else{
           //if user not signin
           setUpSignInViewController()
        }
        
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    // Google sign function
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
       
        if let error = error{
            print(error.localizedDescription)
        } else{
            guard let authentication = user.authentication else{
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
                
                if error == nil{
                    
                    self.userDefault.set(true, forKey: SIGNIN)
                    self.userDefault.set("Pune", forKey: CITY)
                    self.userDefault.synchronize()
                    //After login goto hone viewcontroller
                    self.setUpHomeViewController()
                    
                } else{
                    print(error?.localizedDescription)
                }
            }
        }
        
    }
    //Mark :- Setup home view as root view
    func setUpHomeViewController(){
        
        let homeViewController = HomeViewController()
        let homeNavigationController : UINavigationController = UINavigationController()
        setupNavigationBar(navBar: homeNavigationController.navigationBar)
        homeNavigationController.isNavigationBarHidden = true
        homeNavigationController.pushViewController(homeViewController, animated: false)
        self.window?.rootViewController = homeNavigationController
        self.window?.makeKeyAndVisible()
        
    }
    
    //Mark :- Setup signin view as root view
    func setUpSignInViewController(){
        
        let svc = SignInViewController()
        window?.rootViewController = svc
        window?.makeKeyAndVisible()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
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


}

