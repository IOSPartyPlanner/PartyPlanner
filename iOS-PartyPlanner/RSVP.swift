//
//  RSVP.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

enum RsvpResponse {
  case yes
  case maybe
  case no
  case notResponded
}

import UIKit

class RSVP: NSObject {

  var event: [Event]?
  
  var guest: User?
  
  // the number of persons coming with the guest
  var guestPlusX: Int?
  
  var response: RsvpResponse? = .notResponded
  
}
