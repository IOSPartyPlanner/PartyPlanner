//
//  HomeTaskTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/4/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class HomeTaskTableViewCell: UITableViewCell {

    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    
    var task : Task? {
        didSet {
            
            if let name = task?.name {
                taskNameLabel.text = name
            }
        
            if let time = task?.dueDate{
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .long
                dueDateLabel.text = dateFormatter.string(from: (time))
                
                let dayOfEvent = Calendar.current.component(.day, from: time)
                dayLabel.text = String(dayOfEvent)
                let monthOfEvent = Calendar.current.component(.month, from: time)
                monthLabel.text = Utils.getMonth(month: monthOfEvent)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
