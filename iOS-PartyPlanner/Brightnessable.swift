//
//  Brightnessable.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/9/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import CoreImage

protocol Brightnessable: Processable {
    var minBrightnessValue: Float { get }
    var maxBrightnessValue: Float { get }
    var currentBrightnessValue: Float { get }
    func brightness(_ brightness: Float)
}

extension Brightnessable {
    
    var minBrightnessValue: Float {
        return -1.00
    }
    
    var maxBrightnessValue: Float {
        return 1.00
    }
    
    var currentBrightnessValue: Float {
        return filter.value(forKey: kCIInputBrightnessKey) as? Float ?? 0.00
    }
    
    func brightness(_ brightness: Float) {
        self.filter.setValue(brightness, forKey: kCIInputBrightnessKey)
    }
}

