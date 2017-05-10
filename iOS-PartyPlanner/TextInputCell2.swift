//
//  TextInputCell2.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/9/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit


@objc protocol TextInputCell2Delegate {
  // Event Name
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, eventNameEntered eventName: String)
  
  // Location
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, locationInputStarted location: String)
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, locationInputSelected location: String)
  
  // Start Date
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, startDateTimeStarted row: Int)
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, startDateTimeSelected row: Int)
  
  // End Date
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, endDateTimeStarted row: Int)
  @objc optional func textInputCell2(textInputCell2: TextInputCell2, endDateTimeSelected row: Int)
}

class TextInputCell2: UITableViewCell {
  
  @IBOutlet weak var textInput: CustomTextField!
  
  var indexRow: Int!
  weak var delegate: TextInputCell2Delegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    textInput.delegate = self
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
}

extension TextInputCell2: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if indexRow == 1 {
      print("you selected 1")
    }
    else if indexRow == 2 {
      print("you selected 2")
      //TODO: for location open new page
      delegate?.textInputCell2!(textInputCell2: self, locationInputStarted: "Location")
    }
    else if indexRow == 3 {
      print("you selected Start Date")
      //      textField.resignFirstResponder()
      delegate?.textInputCell2!(textInputCell2: self, startDateTimeStarted: indexRow)
    }
    else if indexRow == 4 {
      print("you selected End Date")
      //      textField.resignFirstResponder()
      delegate?.textInputCell2!(textInputCell2: self, endDateTimeStarted: indexRow)
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if indexRow == 1 {
      print("you completed 1")
      delegate?.textInputCell2!(textInputCell2: self, eventNameEntered: textInput.text!)
    }
    else if indexRow == 2 { }
    else if indexRow == 3 { }
    else if indexRow == 4 { }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

