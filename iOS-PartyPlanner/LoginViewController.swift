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
//    @IBOutlet weak var tLoginButton: UIButton!
    
  override func viewDidLoad() {
    
//    FIRAuth.auth()?.addStateDidChangeListener { auth, user in
//        if let user = user {
//            print("User is signed in.")
//        } else {
//            print("User is signed out.")
//        }
//    }
    
    super.viewDidLoad()
    
    view.addSubview(fbLoginButton)
    fbLoginButton.addTarget(self, action: #selector(handleFbLogin), for: .touchUpInside)
    
    view.addSubview(gLoginButton)
    gLoginButton.addTarget(self, action: #selector(handleGLogin), for: .touchUpInside)
    
//    view.addSubview(tLoginButton)
//    tLoginButton.addTarget(self, action: #selector(handleTLogin), for: .touchUpInside)
    
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().delegate = self
  }
    
//    func handleTLogin() {
//        
//        Twitter.sharedInstance().logIn { (session, error) in
//            if error != nil {
//                print("Twitter login failed", error ?? "")
//                return
//            }
//            guard let token = session?.authToken else {return}
//            guard let secret = session?.authTokenSecret else { return }
//            let credentials = FIRTwitterAuthProvider.credential(withToken: token, secret: secret)
//            
//            self.signIntoFirebase(credentials: credentials)
//            self.performSegue(withIdentifier: "EventViewSegue", sender: self)
//        }
//        
//        let client = TWTRAPIClient.withCurrentUser()
//        let request = client.urlRequest(withMethod: "GET",
//                                        url: "https://api.twitter.com/1.1/account/verify_credentials.json",
//                                                  parameters: ["include_email": "true", "skip_status": "true"],
//                                                  error: nil)
//        
//        client.sendTwitterRequest(request) { response, data, connectionError in
//            print(data)
//            print(response)
//        }
//        
//    }
    

    func handleFbLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("FB login failed", error ?? "")
                return
            }
            
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else {return}
            let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)

            self.signIntoFirebase(credentials: credentials, .Facebook)
            self.performSegue(withIdentifier: "EventViewSegue", sender: self)
            self.showEmail()
            
        }
    }

    func handleGLogin(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Signed in for GUser", user.profile.email)
        
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        signIntoFirebase(credentials: credential, .Google)
        performSegue(withIdentifier: "EventViewSegue", sender: self)
    }
  
  func showEmail(){
    
    FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
      if error != nil {
        print("FBSDKGraphRequest failed", error ?? "")
        return
      }
      print(result ?? "")
    }
  }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func signIntoFirebase(credentials: FIRAuthCredential, _ authType:AuthenticationType){
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Failed to login to firebase", error ?? "")
                return
            }
          
          print("Successful login to firebase", user ?? "")
            
          var uuid:String = (user?.email?.replacingOccurrences(of: ".", with: ""))!
          uuid = uuid.replacingOccurrences(of: "@", with: "")
          uuid = uuid + authType.rawValue
          print(uuid)
          User.currentUser = User(name: (user?.displayName)!, email: user?.email, imageUrl: user?.photoURL, authType: authType.rawValue, uid: uuid)
        })
    }
}

