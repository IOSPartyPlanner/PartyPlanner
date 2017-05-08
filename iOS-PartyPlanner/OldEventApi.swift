//
//  EventApi.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/29/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation
import Firebase

@objc protocol OldEventApiDelegate {
    @objc optional func eventApi(eventApi: OldEventApi, eventUpdated event: Event)
}

class OldEventApi: NSObject {
    
    static let sharedInstance = OldEventApi()
    
    private let fireBaseEventRef = FIRDatabase.database().reference(withPath: "event")
    weak var delegate: OldEventApiDelegate?
    
    func storeEvent(event: Event) {
        let eventRef = fireBaseEventRef.child(event.id)
        eventRef.setValue(event.toAnyObject())
        delegate?.eventApi!(eventApi: self, eventUpdated: event)
    }
    
    
    func getEventById(eventId: String, success: @escaping (Event?) ->(), failure: @escaping () -> ()) {
        print("EventApi : searching for event by Id: \(eventId)")
        var event: Event?
        
        fireBaseEventRef.queryOrdered(byChild: "id")
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
        var events = [Event]()
        fireBaseEventRef.queryOrdered(byChild: "hostEmail")
            .queryEqual(toValue: userEmail)
            .observe(.value, with: { (snapshot) in
                for userEvent in snapshot.children {
                    let event = Event(snapshot: userEvent as! FIRDataSnapshot)
                    events.append(event)
                }
                
                if events == nil {
                    print(userEmail)
                    failure()
                } else {
                    success(events)
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
    
    // return an array of events that this user is invited to
    func getEventsForUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: @escaping () -> ()) {
        print("EventApi : searching for events userId: \(userEmail) is invited to")
        
        RsvpApi.sharedInstance.getRsvpsForUserEmail(
            userEmail: userEmail,
            success: { (rsvps) in
                var eventRsvps : [RSVP] = []
                // get list of eventIds the user is invited to
                for rsvp in rsvps {
                    eventRsvps.append(rsvp)
                }
                
                var events : [Event] = []
                
                let group = DispatchGroup()
                let syncQueue = DispatchQueue(label: "com.domain.app.sections")
                
                for eventRsvp in  eventRsvps {
                    group.enter()
                    self.getEventById(eventId:eventRsvp.eventId ,
                                      success: { (event) in
                                        syncQueue.async {
                                            event?.response = eventRsvp.response.map { $0.rawValue }
                                            events.append(event!)
                                            group.leave()
                                        }
                                        
                    },
                                      
                                      failure: {
                                        print("Error fetching events")
                    })
                }
                
                group.notify(queue: .main) {
                    success(events)
                }
                
        })
        {
            print("Error fetching RSVPS for user")
            failure()
        }
    }
    
    // return an array of upcoming events that this user is invited to
    func getUpcomingEventsForUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: @escaping () -> ()) {
        print("EventApi : searching for upcoming events userId: \(userEmail) is invited to\n")
        getEventsForUserEmail(
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
    
    
    // return an array of upcoming events that this user is invited to
    func getPastEventsForUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: @escaping () -> ()) {
        print("EventApi : searching for past events userId: \(userEmail) is invited to\n")
        getEventsForUserEmail(
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
    
    
    
}
