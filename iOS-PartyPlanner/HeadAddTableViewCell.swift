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
      
      titleLabel.textColor = UIColor.white
      self.contentView.layer.cornerRadius = 10
      self.contentView.layer.borderWidth = 1.0
      self.contentView.layer.borderColor = UIColor.white.cgColor
      
      self.contentView.layer.shadowColor = UIColor.black.cgColor
      self.contentView.layer.shadowOpacity = 0.5
      self.contentView.layer.shadowRadius = 10.0
      self.contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
      
//      
//      self.contentView.layer.cornerRadius = 10
//      self.contentView.layer.borderWidth = 10.0
//      self.contentView.layer.borderColor = UIColor.red.cgColor
//      
//      self.contentView.layer.shadowColor = UIColor.black.cgColor
//      self.contentView.layer.shadowOpacity = 0.3
//      self.contentView.layer.shadowRadius = 10.0
//      self.contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
