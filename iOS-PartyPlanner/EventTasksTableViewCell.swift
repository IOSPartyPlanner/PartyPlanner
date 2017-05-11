//
//  EventTasksTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 5/7/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EventTasksTableViewCell: UITableViewCell {

    @IBOutlet weak var taskImageView: UIImageView!
    
    @IBOutlet weak var taskDescLabel: UILabel!
    
    var viewController: EventViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
