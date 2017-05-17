//
//  TextInputCell2.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/9/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import Material

@objc protocol TextInputCell2Delegate {
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, eventNameEntered eventName: String)
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, locationInputStarted location: String)
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, startDateTimeStarted row: Int)
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, endDateTimeStarted row: Int)
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, detailsEntered eventDetails: String)
}

class TextInputCell2: UITableViewCell {
  
  var indexRow: Int!
  weak var delegate: TextInputCell2Delegate?
  
  @IBOutlet weak var textInput: TextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    textInput.delegate = self
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

extension TextInputCell2: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if indexRow == 1 {
      print("you selected 1")
    }
    else if indexRow == 2 {
      print("you selected 2")
      delegate?.textInputCell2!(textInputCell2: self, locationInputStarted: "Location")
    }
    else if indexRow == 3 {
      print("you selected Start Date")
      delegate?.textInputCell2!(textInputCell2: self, startDateTimeStarted: indexRow)
    }
    else if indexRow == 4 {
      print("you selected End Date")
      delegate?.textInputCell2!(textInputCell2: self, endDateTimeStarted: indexRow)
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if indexRow == 1 {
      print("you entered event name")
      delegate?.textInputCell2!(textInputCell2: self, eventNameEntered: textInput.text!)
    }
    if indexRow == 5 {
      print("you entered event details")
      delegate?.textInputCell2!(textInputCell2: self, detailsEntered: textInput.text!)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

