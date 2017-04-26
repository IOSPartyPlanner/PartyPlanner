//
//  User.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

enum AuthenticationType {
  case PartyPlanner
  case Google
  case Facebook
  case Twitter
}

class User: NSObject {
  
  var id: String?
  
  var userName: String?
  
  var passwordHash: String?
  
  var name: String?
  
  var email: String?
  
  var phone: String?
  
  var address: Date?
  
  var imageUrl: URL?
  
  var authType: AuthenticationType?
  
  var authToken: String?
  
}
