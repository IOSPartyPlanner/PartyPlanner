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
  @objc optional func imageCell(imageCell: ImageCell, videoPlay: Bool)
}


class ImageCell: UITableViewCell {
  
  @IBOutlet weak var myImageView: UIImageView!
  @IBOutlet weak var mediaSelectionButton: UIButton!
  var mediaType = MediaType.image
  
  weak var delegate: ImageCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func onPlayButton(_ sender: Any) {
    delegate?.imageCell!(imageCell: self, videoPlay: true)
  }
  
  // mark: - Media Selection
  @IBAction func onCameraButton(_ sender: Any) {
    delegate?.imageCell!(imageCell: self, media: "Media")
  }
  
}
