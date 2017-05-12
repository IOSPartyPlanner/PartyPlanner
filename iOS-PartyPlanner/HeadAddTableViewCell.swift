//
//  HeadAddTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 5/12/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class HeadAddTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addImageView: UIImageView! 
    
    var viewController: EventViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
