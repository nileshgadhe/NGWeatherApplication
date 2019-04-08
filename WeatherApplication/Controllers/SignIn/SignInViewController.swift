//
//  SignInViewController.swift
//  WeatherApplication
//
//  Created by Mac on 07/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

       GIDSignIn.sharedInstance().uiDelegate = self
    }

}
