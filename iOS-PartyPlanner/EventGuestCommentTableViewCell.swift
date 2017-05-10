//
//  EventTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EventGuestCommentTableViewCell: UITableViewCell {
    var comment: Comment? {
        didSet {
            guestImageView.setImageWith((comment?.userImageURL)!)
            guestName.text = comment?.userName
            guestComment.text = comment?.text
        }
    }

    @IBOutlet weak var guestImageView: UIImageView!
    
    @IBOutlet weak var guestName: UILabel!
    
    @IBOutlet weak var guestComment: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
