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
import CoreImage

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UserApiDelegate{

  
  var animator: UIDynamicAnimator!
  var gravity: UIGravityBehavior!
  var collision: UICollisionBehavior!
  var elastic: UIDynamicItemBehavior!
  
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var gLoginButton: UIButton!
  
  

  @IBOutlet weak var g1: UIImageView!
  @IBOutlet weak var g2: UIImageView!
  @IBOutlet weak var g3: UIImageView!
  @IBOutlet weak var g4: UIImageView!
  @IBOutlet weak var g5: UIImageView!
  @IBOutlet weak var g6: UIImageView!
  @IBOutlet weak var g7: UIImageView!
  @IBOutlet weak var g8: UIImageView!
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    animator = UIDynamicAnimator(referenceView: self.view)
    
    let gs:[UIImageView] = [g1, g2, g3, g4, g5, g6, g7, g8]
    
    gravity = UIGravityBehavior()
    animator.addBehavior(gravity)
    
    collision = UICollisionBehavior()
    animator.addBehavior(collision)
    
    elastic = UIDynamicItemBehavior(items: gs)//images)
    elastic.elasticity = 1
    elastic.friction = 1
    animator.addBehavior(elastic)
    
    gravity.gravityDirection = CGVector(dx: 0, dy: 0.1)
    collision.translatesReferenceBoundsIntoBoundary = true
    
      for image in gs{
        self.gravity.addItem(image)
        self.collision.addItem(image)
      }
    

    
    UIView.animate(withDuration: 10, delay: 0, options: .repeat, animations: {
      for image in gs{
        self.gravity.addItem(image)
        self.collision.addItem(image)
      }
      let imV = UIImageView(image: self.g5.image)
      self.view.addSubview(imV)
      self.gravity.addItem(imV)
      self.collision.addItem(imV)
      
      self.g1.center = CGPoint(x: self.g1.center.x, y: 600)
      self.g2.center = CGPoint(x: self.g2.center.x, y: 600)
      self.g3.center = CGPoint(x: self.g3.center.x, y: 600)
      self.g4.center = CGPoint(x: self.g4.center.x, y: 600)
      self.g5.center = CGPoint(x: self.g5.center.x, y: 600)
      self.g6.center = CGPoint(x: self.g6.center.x, y: 600)
      self.g7.center = CGPoint(x: self.g7.center.x, y: 600)
      self.g8.center = CGPoint(x: self.g8.center.x, y: 600)
      imV.removeFromSuperview()
    }) { (bool: Bool) in
      UIView.animate(withDuration: 10, animations: { 
        for image in gs{
          self.gravity.addItem(image)
          self.collision.addItem(image)
        }
      })
    }
    
    
    fbLoginButton.backgroundColor = .clear
    fbLoginButton.layer.cornerRadius = 10
//    fbLoginButton.layer.borderWidth = 1
//    fbLoginButton.layer.borderColor = UIColor.black.cgColor

    view.addSubview(fbLoginButton)
    fbLoginButton.addTarget(self, action: #selector(handleFbLogin), for: .touchUpInside)

    
    gLoginButton.backgroundColor = .clear
    gLoginButton.layer.cornerRadius = 10
//    gLoginButton.layer.borderWidth = 1
//    gLoginButton.layer.borderColor = UIColor.black.cgColor

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

