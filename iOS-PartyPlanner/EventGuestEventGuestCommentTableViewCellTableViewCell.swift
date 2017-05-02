//
//  EventGuestsTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EventGuestCommentTableViewCell: UITableViewCell {
    var comments: UserComments? {
        didSet {
            guestImageView.setImageWith((comments?.userImageURL)!)
            guestName.text = comments?.username
            guestComment.text = comments?.comment!
        }
    }

    @IBOutlet weak var guestImageView: UIImageView!
    
    @IBOutlet weak var guestName: UILabel!
    
    @IBOutlet weak var guestComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        guestImageView.layer.cornerRadius = guestImageView.frame.size.width / 2;
        guestImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
