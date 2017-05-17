//
//  CommentsTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/1/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var commentLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            
            if let name = comment?.userName{
                userNameLabel.text = name
            }
            
            if let comment = comment?.text{
                commentLabel.text = comment
            }

           Utils.formatCircleImage(image: userProfileImageView)
            
            /*if let imageUrl = comment?.imageUrl{
                //TODO:Set image
            }*/
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
