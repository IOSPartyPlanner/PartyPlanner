//
//  rsvp.model.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation

class Rsvp :NSObject {
  
  var event: [Event]?
  
  var guest: User?
  
  // the number of persons coming with the guest
  var guestPlusX: Int?
  
  var response: rsvpResponse? = .notResponded
}
