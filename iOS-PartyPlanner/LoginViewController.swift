//
//  ViewController.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/24/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var gLoginButton: GIDSignInButton!
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(fbLoginButton)
    fbLoginButton.delegate = self
    
    view.addSubview(gLoginButton)
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().signIn()
    
  }

  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("fb logout")
    }
    
  func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        }
        else {
            print("fb logged in")
        }
    
        showAccount()
    }
    
    func showAccount(){

        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("FIREBase fb addition error", error ?? "")
                return
            }
            print("Successful logged into firebase", user ?? "")
        })
            
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            if error != nil {
                print("error in fetching  graph",error as Any)
                return
            }
            print(result ?? "")
        }
    }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }


}

