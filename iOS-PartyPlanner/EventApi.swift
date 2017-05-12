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
    
    
    func getEventById(eventId: String, success: @escaping (Event?) ->(), failure: ((APIFetchError) -> ())?) {
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
                    failure?(.NoItemFoundError)
                } else {
                    success(event)
                }
            })
    }
    
    func getEventsHostedByUserEmailWithPredicate(userEmail: String, predicate: ((Event) -> Bool)?, success: @escaping ([Event]) -> (), failure: ((APIFetchError) -> ())?) {
        print("EventApi : searching for events hosted by userId: \(userEmail)")
        fireBaseEventRef.queryOrdered(byChild: "hostEmail")
            .queryEqual(toValue: userEmail)
            .observe(.value, with: { (snapshot) in
                
                var events = snapshot.children.map({ return Event(snapshot: $0 as! FIRDataSnapshot)})
                
                if let predicate = predicate {
                    events = events.filter{
                        print($0.dateTime.timeIntervalSinceNow)
                        print(predicate($0))
                        return predicate($0)
                    }
                }
                
                if events.count == 0 {
                    failure?(.NoItemFoundError)
                } else {
                    success(events)
                }
            })
    }
    
    func getEventsHostedByUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: ((APIFetchError) -> ())?) {
        print("EventApi : searching for events hosted by userId: \(userEmail)")
        getEventsHostedByUserEmailWithPredicate(userEmail: userEmail, predicate: nil, success: success, failure: failure)
    }
    
    func getUpcomingEventsHostedByUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: ((APIFetchError) -> ())?) {
        print("EventApi : searching for upcoming events hosted by userId: \(userEmail)")
        getEventsHostedByUserEmailWithPredicate(userEmail: userEmail, predicate: { return $0.dateTime.timeIntervalSinceNow > 0 }, success: success, failure: failure)
    }
    
    func getPastEventsHostedByUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: ((APIFetchError) -> ())?) {
        print("EventApi : searching for past events hosted by userId: \(userEmail)")
        getEventsHostedByUserEmailWithPredicate(userEmail: userEmail, predicate: { return $0.dateTime.timeIntervalSinceNow <= 0 }, success: success, failure: failure)
    }
    
    // return an array of events that this user is invited to
    func getEventsForUserEmailWithPredicate(userEmail: String, predicate: ((Event) -> Bool)?, success: @escaping ([Event]) -> (), failure: ((APIFetchError) -> ())?) {
        print("EventApi : searching for events userId: \(userEmail) is invited to")
        
        RsvpApi.sharedInstance.getRsvpsForUserEmail(userEmail: userEmail, success: {rsvps in
            let revpIds = rsvps.map{    return $0.eventId   }
            self.fireBaseEventRef.queryOrdered(byChild: "hostEmail")
                .queryEqual(toValue: userEmail)
                .observe(.value, with: { (snapshot) in
                    var events = snapshot.children.map({ return Event(snapshot: $0 as! FIRDataSnapshot)}).filter{ revpIds.contains($0.id)}
                    
                    if let predicate = predicate {
                        events = events.filter{ return predicate($0) }
                    }
                    
                    
                    if events.count == 0 {
                        failure?(.NoItemFoundError)
                    } else {
                        success(events)
                    }
                })
            
        }, failure: {
            failure?(.NoItemFoundError)
        })
    }
    
    func getEventsForUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: ((APIFetchError) -> ())?) {
        print("EventApi : searching for events userId: \(userEmail) is invited to")
        getEventsForUserEmailWithPredicate(userEmail: userEmail, predicate: nil, success: success, failure: failure)
    }
    
    // return an array of upcoming events that this user is invited to
    func getUpcomingEventsForUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: ((APIFetchError) -> ())?) {
        print("EventApi : searching for upcoming events userId: \(userEmail) is invited to\n")
        getEventsForUserEmailWithPredicate(userEmail: userEmail, predicate: { return $0.dateTime.timeIntervalSinceNow > 0 }, success: success, failure: failure)
    }
    
    
    // return an array of upcoming events that this user is invited to
    func getPastEventsForUserEmail(userEmail: String, success: @escaping ([Event]) -> (), failure: ((APIFetchError) -> ())?) {
        print("EventApi : searching for past events userId: \(userEmail) is invited to\n")
        getEventsForUserEmailWithPredicate(userEmail: userEmail, predicate: { return $0.dateTime.timeIntervalSinceNow <= 0 }, success: success, failure: failure)
    }
    
    func addPhotoURL(_ imageURL: String, withEvent event: Event) {
        event.postEventImages?.append(imageURL)
        storeEvent(event: event)
    }
}
