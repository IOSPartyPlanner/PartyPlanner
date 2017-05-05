//
//  EventApi.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/29/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation
import Firebase

@objc protocol EventApiDelegate {
  @objc optional func eventApi(eventApi: EventApi, eventUpdated event: Event)
}

class EventApi: NSObject {
  
  static let sharedInstance = EventApi()
  
  private let fireBaseEventRef = FIRDatabase.database().reference(withPath: "event")
  weak var delegate: EventApiDelegate?
  
  func storeEvent(event: Event) {
    let eventRef = fireBaseEventRef.child(event.id)
    eventRef.setValue(event.toAnyObject())
    delegate?.eventApi!(eventApi: self, eventUpdated: event)
  }
  
  
  func getEventById(eventId: String, success: @escaping (Event?) ->(), failure: @escaping () -> ()) {
    print("EventApi : searching for event by Id: \(eventId)")
    var event: Event?
    fireBaseEventRef.queryOrdered(byChild: "eventId")
      .queryEqual(toValue: eventId)
      .observe(.value, with: { (snapshot) in
        for taskEvent in snapshot.children {
          event = Event(snapshot: taskEvent as! FIRDataSnapshot)
          break
        }
        
        if event == nil {
          failure()
        } else {
          success(event)
        }
      })
  }
  
  func getEventsHostedByUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: @escaping () -> ()) {
    print("EventApi : searching for events hosted by userId: \(userEmail)")
    var events: [Event]?
    fireBaseEventRef.queryOrdered(byChild: "userEmail")
      .queryEqual(toValue: userEmail)
      .observe(.value, with: { (snapshot) in
        for userEvent in snapshot.children {
          let event = Event(snapshot: userEvent as! FIRDataSnapshot)
          events?.append(event)
        }
        
        if events == nil {
          failure()
        } else {
          success(events!)
        }
      })
  }
  
  func getUpcomingEventsHostedByUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: @escaping () -> ()) {
    print("EventApi : searching for upcoming events hosted by userId: \(userEmail)")
    getEventsHostedByUserEmail(
      userEmail: userEmail,
      success: { (events) in
        var upcomingEvents: [Event] = []
        for event in events {
          if event.dateTime.timeIntervalSinceNow > 0 {
            upcomingEvents.append(event)
          }
        }
        success(upcomingEvents)
    },
      failure: {
    })
  }
  
  func getPastEventsHostedByUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: @escaping () -> ()) {
    print("EventApi : searching for past events hosted by userId: \(userEmail)")
    getEventsHostedByUserEmail(
      userEmail: userEmail,
      success: { (events) in
        var pastEvents: [Event] = []
        for event in events {
          if event.dateTime.timeIntervalSinceNow < 0 {
            pastEvents.append(event)
          }
        }
        success(pastEvents)
    },
      failure: {
    })
  }
  
  func getEventsAttendedByUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: @escaping () -> ()) {
    print("EventApi : searching for events hosted by userId: \(userEmail)")
    var events: [Event]?
    fireBaseEventRef.queryOrdered(byChild: "userEmail")
      .queryEqual(toValue: userEmail)
      .observe(.value, with: { (snapshot) in
        for userEvent in snapshot.children {
          let event = Event(snapshot: userEvent as! FIRDataSnapshot)
          events?.append(event)
        }
        
        if events == nil {
          failure()
        } else {
          success(events!)
        }
      })
  }
  
  
  
}
