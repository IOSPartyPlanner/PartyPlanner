//
//  TextInputCell.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/7/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

@objc protocol TextInputCellDelegate {
  // Event Name
  @objc optional func textInputCellDelegate (textInputCellDelegate: TextInputCell, eventNameEntered name: String)
  
  // Location
  @objc optional func textInputCellDelegate (textInputCellDelegate: TextInputCell, locationInputStarted location: String)
  @objc optional func textInputCellDelegate (textInputCellDelegate: TextInputCell, locationInputSelected location: String)
  
  // Start Date
  @objc optional func textInputCellDelegate (textInputCellDelegate: TextInputCell, startDateTimeStarted startDate: String)
  @objc optional func textInputCellDelegate (textInputCellDelegate: TextInputCell, startDateTimeSelected startDate: Date)
  
  // End Date
  @objc optional func textInputCellDelegate (textInputCellDelegate: TextInputCell, endDateTimeStarted endDate: String)
  @objc optional func textInputCellDelegate (textInputCellDelegate: TextInputCell, endDateTimeSelected endDate: Date)
}

class TextInputCell: UITableViewCell {
  
  @IBOutlet weak var textInput: CustomTextField!
  var indexRow: Int = -1
  
  weak var delegate: TextInputCellDelegate?
  
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

extension TextInputCell: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if indexRow == 1 {
      print("you selected 1")
    }
    else if indexRow == 2 {
      print("you selected 2")
      //TODO: for location open new page
    }
    else if indexRow == 3 {
      print("you selected Start Date")
      delegate?.textInputCellDelegate!(textInputCellDelegate: self, startDateTimeStarted: "StartTime")
    }
    else if indexRow == 4 {
      print("you selected End Date")
      delegate?.textInputCellDelegate!(textInputCellDelegate: self, endDateTimeStarted: "EndTime")
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if indexRow == 1 {
      print("you completed 1")
      delegate?.textInputCellDelegate!(textInputCellDelegate: self, eventNameEntered: textInput.text!)
    }
    else if indexRow == 2 {
      print("you selected 2")
      //TODO: for location open new page
    }
    else if indexRow == 3 {
      print("you selected Start Date")
      delegate?.textInputCellDelegate!(textInputCellDelegate: self, startDateTimeSelected: Date.init())
    }
    else if indexRow == 4 {
      print("you selected End Date")
      delegate?.textInputCellDelegate!(textInputCellDelegate: self, endDateTimeSelected: Date.init())
    }
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

