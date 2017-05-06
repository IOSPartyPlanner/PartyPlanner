//
//  HomeEventTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/4/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import AFNetworking

class HomeEventTableViewCell: UITableViewCell {
    
    
    @IBOutlet var invitationImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var eventTimeLabel: UILabel!
    @IBOutlet var eventLocationLabel: UILabel!
    @IBOutlet var rsvpButton: UIButton!
    
    var event: Event? {
        didSet {
            if let profileImageURL = event?.hostProfileImage{
                profileImageView.setImageWith(NSURL(string:profileImageURL)! as URL)
            }
            
            if let invitationImageURL = event?.inviteMediaUrl{
                invitationImageView.setImageWith(NSURL(string:invitationImageURL)! as URL)
            }
            
            if let name = event?.name {
                eventNameLabel.text = name
            }
            
            if let address = event?.location{
               eventLocationLabel.text = address
            }
            
            if let time = event?.dateTime{
                eventTimeLabel.text = Utils.getTimeStampStringFromDate(date: time)
            }
            
            if let rsvpStatus = event?.response {
                rsvpButton.setTitle(rsvpStatus, for: .normal)
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
