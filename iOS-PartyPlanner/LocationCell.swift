//
//  LocationCell.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/9/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
  
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  var location: NSDictionary! {
    didSet {
      nameLabel.text = location["name"] as? String
      addressLabel.text = location.value(forKeyPath: "location.address") as? String
      
      let categories = location["categories"] as? NSArray
      if (categories != nil && categories!.count > 0) {
        let category = categories![0] as! NSDictionary
        let urlPrefix = category.value(forKeyPath: "icon.prefix") as! String
        let urlSuffix = category.value(forKeyPath: "icon.suffix") as! String
        
        let url = "\(urlPrefix)bg_32\(urlSuffix)"
//        categoryImageView.setImageWith(URL(string: url)!)
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
