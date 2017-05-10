//
//  TextInputCell.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/7/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

//@objc protocol TextInputCellDelegate {
//  // Event Name
//  @objc optional func textInputCell(textInputCell: TextInputCell, eventNameEntered name: String)
//  
//  // Location
//  @objc optional func textInputCell(textInputCell: TextInputCell, locationInputStarted location: String)
//  @objc optional func textInputCell(textInputCell: TextInputCell, locationInputSelected location: String)
//  
//  // Start Date
//  @objc optional func textInputCell(textInputCell: TextInputCell, startDateTimeStarted row: Int)
//  @objc optional func textInputCell(textInputCell: TextInputCell, startDateTimeSelected row: Int)
//  
//  // End Date
//  @objc optional func textInputCell(textInputCell: TextInputCell, endDateTimeStarted row: Int)
//  @objc optional func textInputCell(textInputCell: TextInputCell, endDateTimeSelected row: Int)
//}

class TextInputCell: UITableViewCell {
  
  @IBOutlet weak var textInput: CustomTextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  var indexRow: Int = -1
//  var datePickerHidden = true
  
//  weak var delegate: TextInputCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
//    textInput.delegate = self
    datePicker.isHidden = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

//extension TextInputCell: UITextFieldDelegate {
//  func textFieldDidBeginEditing(_ textField: UITextField) {
//    if indexRow == 1 {
//      print("you selected 1")
//    }
//    else if indexRow == 2 {
//      print("you selected 2")
//      //TODO: for location open new page
//    }
//    else if indexRow == 3 {
//      print("you selected Start Date")
////      textField.resignFirstResponder()
//      delegate?.textInputCell!(textInputCell: self, startDateTimeStarted: indexRow)
//    }
//    else if indexRow == 4 {
//      print("you selected End Date")
////      textField.resignFirstResponder()
//      delegate?.textInputCell!(textInputCell: self, endDateTimeStarted: indexRow)
//    }
//  }
//  
//  func textFieldDidEndEditing(_ textField: UITextField) {
//    if indexRow == 1 {
//      print("you completed 1")
//      delegate?.textInputCell!(textInputCell: self, eventNameEntered: textInput.text!)
//    }
//    else if indexRow == 2 {
//      print("you selected 2")
//      //TODO: for location open new page
//    }
//    else if indexRow == 3 {
//      print("you selected Start Date")
////      delegate?.textInputCell!(textInputCell: self, startDateTimeSelected: indexRow)
//    }
//    else if indexRow == 4 {
//      print("you selected End Date")
////      delegate?.textInputCell!(textInputCell: self, endDateTimeSelected: indexRow)
//    }
//  }
//  
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    textField.resignFirstResponder()
//    return true
//  }
//  
//  func datePickerValueChanged(sender: Any) {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = DateFormatter.Style.medium
//    dateFormatter.timeStyle = DateFormatter.Style.medium
//    
//    print("\n\n date:::::khdjh \n")
//  }
//
  
//}

