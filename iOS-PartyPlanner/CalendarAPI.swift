//
//  CalendarAPI.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 5/3/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import EventKit

class CalendarAPI: NSObject {
    func createPartyEvent(event: Event?) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (success, error) in
            
        })
        
        let calendar = eventStore.defaultCalendarForNewEvents
        
        let calEvent = EKEvent(eventStore: eventStore)
        calEvent.title = (event?.name)!
        
        calEvent.calendar = calendar
        let tomorrowOneHour = Calendar.current.date(byAdding: .hour, value: 25, to: Date())
        calEvent.startDate = (event?.dateTime)!
        calEvent.endDate = calEvent.startDate.addingTimeInterval((event?.peroid)!)
        try! eventStore.save(calEvent, span: EKSpan.thisEvent, commit: true)
    }
}
