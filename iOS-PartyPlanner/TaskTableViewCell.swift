//
//  TaskTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/6/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var taskStatusImage: UIImageView!
    @IBOutlet var taskDescriptionLabel: UILabel!
    @IBOutlet var peopleCountLabel: UILabel!
    
    var task: Task? {
        didSet {
            if let name = task?.name {
                taskNameLabel.text = name
            }
            
            if let description = task?.taskDescription {
                taskDescriptionLabel.text = description
            }
            
            if let count = task?.numberOfPeopleRequired{
                if task?.volunteerEmails != nil {
                    peopleCountLabel.text = String(count - (task?.volunteerEmails?.count)!)
                }
                else{
                     peopleCountLabel.text = String(count)
                }
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
