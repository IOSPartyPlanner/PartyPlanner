//
//  MediaCollectionViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/1/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mediaImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        mediaImageView.layer.borderWidth = 1
        mediaImageView.layer.borderColor = UIColor.white.cgColor

    }
}
