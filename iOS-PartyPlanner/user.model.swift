//
//  user.model.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation

class User: NSObject {

  var id: String?
  var userName: String?
  var passwordHash: String?
  var name: String?
  var email: String?
  var phone: String?
  var address: Date?
  var imageUrl: URL?
  var authType: userAuthEnum?
  var authToken: String?
  // var favEvents: [EventIds]
}
  
