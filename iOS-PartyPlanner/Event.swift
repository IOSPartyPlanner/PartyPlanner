//
//  event.model.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation

class Event: NSObject {
  
  var id: String?
  
  var name: String?
  
  var tagline: String?
  
  var host: User?
  
  var location: String?
  
  var rsvpList: [Rsvp]?
  
  var taskList: [Task]?
  
  var itemList: [Item]?
  
  var inviteImage: Image?
  
  var inviteVideo: Video?
  
  var giftList: [Gift]?
  
  var postEventImages: [Image]?
  
  var postEventVideos: [Video]?
  
  var likesCount: String?
  
  var postEventComments: [String]?
}
