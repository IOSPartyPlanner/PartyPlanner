//
//  ImageCell.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/7/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

@objc protocol ImageCellDelegate {
  @objc optional func imageCell(imageCell: ImageCell, media: String)
}


class ImageCell: UITableViewCell {
  
  @IBOutlet weak var myImageView: UIImageView!
  weak var delegate: ImageCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // mark: - Media Selection
  @IBAction func onCameraButton(_ sender: Any) {
    delegate?.imageCell!(imageCell: self, media: "Media")
  }
  
  
}
