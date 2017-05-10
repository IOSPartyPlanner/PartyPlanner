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


class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UserApiDelegate{

    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var gLoginButton: UIButton!

    
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.addSubview(fbLoginButton)
    fbLoginButton.addTarget(self, action: #selector(handleFbLogin), for: .touchUpInside)
    
    view.addSubview(gLoginButton)
    gLoginButton.addTarget(self, action: #selector(handleGLogin), for: .touchUpInside)
    
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().delegate = self
  }
    
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
                print("Failed to login to firebase", error?.localizedDescription)
             return }
          
          print("Successful login to firebase", user?.displayName ?? "")
            
          var uuid:String = (user?.email?.replacingOccurrences(of: ".", with: ""))!
          uuid = uuid.replacingOccurrences(of: "@", with: "")
          
          
          let profilePicUrl = user?.photoURL?.absoluteString
          User.currentUser = User(name: (user?.displayName)!, email: user?.email, imageUrl: profilePicUrl, authType: authType.rawValue, uid: uuid)
          User.currentUser?.imageUrl = profilePicUrl
          User.currentUser?.name = (user?.displayName)!
          User.currentUser?.email = (user?.email)!
          User.currentUser?.authType = authType.rawValue
          User.currentUser?.uid = uuid
          
          UserApi.sharedInstance.storeUser(user: User.currentUser!)
          if RSVP.currentInstance == nil {
            self.performSegue(withIdentifier: "EventViewSegue", sender: self)
          }
          else {
            self.performSegue(withIdentifier: "RSVPSegue", sender: self)
          }
       })
    }
}

