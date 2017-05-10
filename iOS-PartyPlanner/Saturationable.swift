//
//  Saturationable.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/9/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import CoreImage

protocol Saturationable: Processable {
    var minSaturationValue: Float { get }
    var maxSaturationValue: Float { get }
    var currentSaturationValue: Float { get }
    func saturation(_ saturation: Float)
}

extension Saturationable {
    
    var minSaturationValue: Float {
        return 0.00
    }
    
    var maxSaturationValue: Float {
        return 2.00
    }
    
    var currentSaturationValue: Float {
        return filter.value(forKey: kCIInputSaturationKey) as? Float ?? 1.00
    }
    
    func saturation(_ saturation: Float) {
        self.filter.setValue(saturation, forKey: kCIInputSaturationKey)
    }
}
