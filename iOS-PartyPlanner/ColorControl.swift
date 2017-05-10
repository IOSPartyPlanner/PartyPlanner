//
//  ColorControl.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/9/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import CoreImage

class ColorControl: Brightnessable, Contrastable, Saturationable {
    
    // MARK: - Properties
    
    let filter = CIFilter(name: "CIColorControls")!
}
