//
//  PhotoAnnotation.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/17/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var photo: UIImage!
    
    var title: String? {
        return "\(coordinate.latitude)"
    }
}
