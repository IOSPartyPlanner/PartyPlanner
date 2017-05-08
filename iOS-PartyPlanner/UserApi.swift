//
//  UserApi.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/30/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation


import Foundation
import Firebase

@objc protocol UserApiDelegate {
  @objc optional func userApi(userApi: UserApi, userUpdated user: User)
}

class UserApi: NSObject {
  
  static let sharedInstance = UserApi()
  private let fireBaseTaskRef = FIRDatabase.database().reference(withPath: "user")
  weak var delegate: UserApiDelegate?
  
  func storeUser(user: User) {
    print("UserAPI : Storing/updating user")
    let userRef = fireBaseTaskRef.child(user.uid)
    userRef.setValue(user.toAnyObject())

    //Adding the ref and key to the stored user.
    let refPath = "user/"+user.uid
    user.ref = FIRDatabase.database().reference(withPath: refPath)
    user.key = user.ref?.key
    
    delegate?.userApi!(userApi: self, userUpdated: user)
  }
  
  func removeUser(user: User){
    if user.ref == nil {
      let refPath = "user/"+user.uid
      user.ref = FIRDatabase.database().reference(withPath: refPath)
      user.key = user.ref?.key
    }
    user.ref?.removeValue()
    
  }
  
  func getUserByEmail(userEmail: String, success: @escaping (User?) ->(), failure: @escaping () -> ()) {
    print("UserAPI : searching for user by Email \(userEmail)")
    var user: User?
    fireBaseTaskRef.queryOrdered(byChild: "email")
      .queryEqual(toValue: userEmail)
      .observe(.value, with: { snapshot in
        for userChild in snapshot.children {
          user = User(snapshot: userChild as! FIRDataSnapshot)
          break
        }
        
        if user == nil {
          failure()
        } else {
          success(user)
        }
      })
  }
}
