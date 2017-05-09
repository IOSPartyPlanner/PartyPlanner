//
//  CustomTextField.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/7/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
  
  @IBInspectable var leftImage: UIImage? {
    didSet {
      updateView()
    }
  }
  
  @IBInspectable var leftPadding: CGFloat = 0 {
    didSet {
      updateView()
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
    }
  }
  
  func updateView() {
    
    if let image = leftImage {
      leftViewMode = .always
      
      let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 20, height: 20))
      imageView.image = image
      imageView.tintColor = tintColor
      
      var width = leftPadding + 30
      // More padding is needed when border styles are none or a line
      if borderStyle == UITextBorderStyle.none ||  borderStyle == UITextBorderStyle.line {
        width = width + 5
      }
      
      let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 30))
      view.addSubview(imageView)
      
      leftView = view
      
    } else {
      leftViewMode = .never
    }
    
    // change color of text to tint color
    attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "" ,
                                               attributes: [NSForegroundColorAttributeName: tintColor])
  }
}
