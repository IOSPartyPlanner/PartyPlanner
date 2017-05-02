//
//  UserComments.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 5/1/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class UserComments: NSObject {
    var username: String?
    
    var userImageURL: URL?
    
    var comment: String?
    
    init(_ user: String, _ url: URL, _ userComment: String) {
        username = user
        userImageURL = url
        comment = userComment
    }
}
