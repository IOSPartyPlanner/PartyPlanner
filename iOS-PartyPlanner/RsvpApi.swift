//
//  RsvpApi.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/29/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation
import Firebase

@objc protocol RsvpApiDelegate {
  @objc optional func rsvpApi(rsvpApi: RsvpApi, taskUpdated rsvp: RSVP)
}


class RsvpApi:  NSObject {
  
  static let sharedInstance = RsvpApi()
  private let fireBaseRsvpRef = FIRDatabase.database().reference(withPath: "rsvp")
  weak var delegate: RsvpApiDelegate?
  
  func storeRsvp(rsvp: RSVP) {
    let rsvpRef = fireBaseRsvpRef.child(rsvp.id)
    rsvpRef.setValue(rsvp.toAnyObject())
    let refPath = "rsvp/" + (RSVP.currentInstance?.id)!
    rsvp.ref =  FIRDatabase.database().reference(withPath: refPath)
    rsvp.key = rsvp.ref?.key
    
    delegate?.rsvpApi!(rsvpApi: self, taskUpdated: rsvp)
  }
  
  func getRsvpById(rsvpId: String, success: @escaping (RSVP?) ->(), failure: @escaping () -> ()) {
    print("RsvpAPI : searching rsvp by ID \(rsvpId)")
    var rsvp: RSVP?
    fireBaseRsvpRef.queryOrdered(byChild: "id")
      .queryEqual(toValue: rsvpId)
      .observe(.value, with: { snapshot in
        for rsvpChild in snapshot.children {
          rsvp = RSVP(snapshot: rsvpChild as! FIRDataSnapshot)
          break
        }
        
        if rsvp == nil {
          failure()
        } else {
          success(rsvp)
        }
      })
  }
  
  func getRsvpsByEventId(eventId: String, success: @escaping ([RSVP]) -> (), failure: @escaping () -> ()) {
    print("RsvpAPI : searching RSVPs by eventId:: \(eventId)")
    var rsvps: [RSVP] = []
    fireBaseRsvpRef.queryOrdered(byChild: "eventId")
      .queryEqual(toValue: eventId)
      .observe(.value, with: { snapshot in
        for rsvpChild in snapshot.children {
          let rsvp = RSVP(snapshot: rsvpChild as! FIRDataSnapshot)
          rsvps.append(rsvp)
        }
        
        if rsvps.count == 0 {
          failure()
        } else {
          success(rsvps)
        }
      })
  }
  
  func getRsvpForUserAndEvent(eventId: String, userEmail: String, success: @escaping (RSVP) -> (), failure: @escaping () -> ()) {
    print("RsvpAPI : searching RSVPs by eventId:: \(eventId) and userId:: \(userEmail)")
    var rsvp: RSVP?
    fireBaseRsvpRef.queryOrdered(byChild: "guestEmail")
      .queryEqual(toValue: userEmail)
      .observe(.value, with: { snapshot in
        for guestRsvpChild in snapshot.children {
          let guestRsvp = RSVP(snapshot: guestRsvpChild as! FIRDataSnapshot)
          if guestRsvp.eventId == eventId {
            rsvp = guestRsvp
            break
          }
        }
        
        if rsvp == nil {
          failure()
        } else {
          success(rsvp!)
        }
      })
  }
}
