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
import TwitterKit


class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{


    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var gLoginButton: UIButton!
    @IBOutlet weak var tLoginButton: UIButton!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(fbLoginButton)
    fbLoginButton.addTarget(self, action: #selector(handleFbLogin), for: .touchUpInside)
    
    view.addSubview(gLoginButton)
    gLoginButton.addTarget(self, action: #selector(handleGLogin), for: .touchUpInside)
    GIDSignIn.sharedInstance().uiDelegate = self
    
    
    view.addSubview(tLoginButton)
    tLoginButton.addTarget(self, action: #selector(handleTLogin), for: .touchUpInside)
    
    GIDSignIn.sharedInstance().delegate = self
   
  }
    
    func handleTLogin() {
        
        Twitter.sharedInstance().logIn { (session, error) in
            if error != nil {
                print("Twitter login failed", error ?? "")
                return
            }
            
            guard let token = session?.authToken else {return}
            guard let secret = session?.authTokenSecret else { return }
            
            let credentials = FIRTwitterAuthProvider.credential(withToken: token, secret: secret)
            
            FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                if error != nil {
                    print("Failed to login to firebase with twitter", error ?? "")
                    return
                }
                print("Successful login to firebase with twitter", user ?? "")
                
            })
            self.performSegue(withIdentifier: "EventViewSegue", sender: self)
        }
    }
    
    func handleGLogin(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    func handleFbLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("FB login failed", error ?? "")
                return
            }
            self.showEmail()
            self.performSegue(withIdentifier: "EventViewSegue", sender: self)
        }
    }

    func showEmail(){
        
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
                print("FBSDKGraphRequest failed", error ?? "")
                return
            }
            print(result ?? "")
        }
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Signed in for GUser", user.profile.email)
        
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Adding gUser to firebase failed", error!)
            }
            else{
                print("Adding gUser to firebase Successful", user?.uid ?? "")
            }
        })
     
        performSegue(withIdentifier: "EventViewSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

