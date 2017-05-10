//
//  EventCreationViewController.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/7/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EventCreationViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var datepicker = UIDatePicker()
  var toolbar = UIToolbar()
<<<<<<< HEAD
  var currentIndex: Int!
  
  var eventStartDateTime: Date!
  var eventEndDateTime: Date!
=======
  var mediaSelectionToolBar = UIToolbar()
  var currentIndex: Int!
  
  var eventName: String?
  
  var eventStartDateTime: Date!
  var eventEndDateTime: Date!
  
  var locationSelected = false
  var location: String?
>>>>>>> eventcreation3
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
<<<<<<< HEAD
    createDatepicker()
    
=======
    prepareToolBars()
    
    // initially set the event start time as currrent time and
    // end time an hour later
>>>>>>> eventcreation3
    eventStartDateTime = Date.init()
    eventEndDateTime = Date.init().addingTimeInterval(60.0)
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    let imageCellNib = UINib(nibName: "ImageCell", bundle: Bundle.main)
    tableView.register(imageCellNib, forCellReuseIdentifier: "ImageCell")
    
    let inputCellNib = UINib(nibName: "TextInputCell", bundle: Bundle.main)
    tableView.register(inputCellNib, forCellReuseIdentifier: "TextInputCell")
  }
  
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "locationSelectionSegue" {
      let vc = segue.destination as! LocationsViewController
      vc.delegate = self
    }
  }
  
<<<<<<< HEAD
  
  
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "locationSelectionSegue" {
      let vc = segue.destination as! LocationsViewController
      vc.delegate = self
    }
  }
  
}

  // MARK: - Location Picker 
extension EventCreationViewController: LocationsViewControllerDelegate {
  
  func locationsPickedLocation(controller: LocationsViewController, location: String) {
    print("Addres picked was \(location)")
=======
}

// MARK: - Location Picker
extension EventCreationViewController: LocationsViewControllerDelegate {
  
  func locationsPickedLocation(controller: LocationsViewController, location: String) {
    locationSelected = true
    print("Addres picked was \(location)")
    self.location = location
    let indexpath = IndexPath(item: currentIndex, section: 0)
    tableView.reloadRows(at: [indexpath], with: .automatic)
  }
  
  func locationsPickedLocation(controller: LocationsViewController, cancelled: String) {
    // TODO: This is a temporary fix for location search view showing up after cancel
    locationSelected = true
>>>>>>> eventcreation3
  }
  
}

  // MARK: - Table
extension EventCreationViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Image
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
      cell.myImageView.image = #imageLiteral(resourceName: "Theme")
      cell.delegate = self
      return cell
    }
      
    else if indexPath.row == 1 {
      // Event Name label
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      cell.textInput.leftImage = #imageLiteral(resourceName: "Pen")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Event Name"
<<<<<<< HEAD
=======
      if eventName != nil {
        cell.textInput.text = eventName
      }
>>>>>>> eventcreation3
      cell.indexRow = indexPath.row
      cell.delegate = self
      return cell
    }
      
    else if indexPath.row == 2 {
      // Location
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      cell.textInput.leftImage = #imageLiteral(resourceName: "Marker")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Location"
      if location != nil {
        cell.textInput.text = location
      }
      cell.indexRow = indexPath.row
      cell.delegate = self
      return cell
    }
      
    else if indexPath.row == 3 {
      // Start Time
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      cell.textInput.leftImage = #imageLiteral(resourceName: "TimerEmpty")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Event Start Date Time"
      cell.indexRow = indexPath.row
      cell.textInput.text = Utils.getShortTimeStampStringFromDate(date: eventStartDateTime)
      cell.textInput.inputView = datepicker
      cell.textInput.inputAccessoryView = toolbar
      cell.delegate = self
      return cell
    }
      
    else if indexPath.row == 4 {
      // End Time
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      cell.textInput.leftImage = #imageLiteral(resourceName: "TimerComplete")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Event End Date Time"
      cell.indexRow = indexPath.row
      cell.textInput.text = Utils.getShortTimeStampStringFromDate(date: eventEndDateTime)
      cell.textInput.inputView = datepicker
      cell.textInput.inputAccessoryView = toolbar
      cell.delegate = self
      return cell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // location
    if indexPath.row == 2 {
      print("you selected location")
    }
  }
}


// MARK: - Date and Media Selection
extension EventCreationViewController {
<<<<<<< HEAD
  //  func showDatePicker() {
  //
  //    datepicker.datePickerMode = UIDatePickerMode.dateAndTime
  //
  //    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.datePickerValueChanged))
  //    toolbar.backgroundColor = UIColor.blue
  //    toolbar.setItems([doneButton], animated: true)
  //    toolbar.isUserInteractionEnabled = true
  //
  //    let pickerSize : CGSize = datepicker.sizeThatFits(CGSize(width: 0, height: 0))
  //    datepicker.frame = CGRect(x: 0, y: 300, width: pickerSize.width, height: 250)
  //
  //    //you probably don't want to set background color as black
  //    datepicker.backgroundColor = UIColor.gray
  //    view.addSubview(datepicker)
  //  }
  
  // Mark: - Date Selection
  func createDatepicker() {
    toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerValueChanged))
    toolbar.setItems([doneButton], animated: true)
=======
  func prepareToolBars() {
    toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerValueChanged))
    toolbar.setItems([doneButton], animated: true)
    
    mediaSelectionToolBar.sizeToFit()
    let changeMediaButton = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: #selector(selectMedia))
    mediaSelectionToolBar.setItems([changeMediaButton], animated: true)
  }
  
  func selectMedia(sender: Any) {
    
>>>>>>> eventcreation3
  }
  
  func datePickerValueChanged(sender: Any) {
    view.endEditing(true)
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeStyle = DateFormatter.Style.medium
    
    let datetime = datepicker.date
    
    // start time selected
    if currentIndex == 3 {
      eventStartDateTime = datetime
      let indexPath = IndexPath(item: currentIndex!, section: 0)
      tableView.reloadRows(at: [indexPath], with: .automatic)
<<<<<<< HEAD
      
=======
>>>>>>> eventcreation3
    } else if currentIndex == 4 {
      // end time selected
      eventEndDateTime = datetime
      let indexPath = IndexPath(item: currentIndex!, section: 0)
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
  }
  
<<<<<<< HEAD
=======
}

// MARK: - Media Selection delegates and methods
extension EventCreationViewController: ImageCellDelegate {
  func imageCell(imageCell: ImageCell, media: String) {
    let alert = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
//      self.openCamera()
    }))
    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//      self.openGallery()
    }))
    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
>>>>>>> eventcreation3
}

// MARK: - TextInputCell delegates
extension EventCreationViewController: TextInputCell2Delegate {
  
  // Event Name filed
<<<<<<< HEAD
  func textInputCell2(textInputCell2: TextInputCell2, eventNameEntered name: String) {
    //    currentIndex = 1
    print(name)
=======
  func textInputCell2(textInputCell2: TextInputCell2, eventNameEntered eventName: String) {
    currentIndex = 1
    locationSelected = false
    
    self.eventName = eventName
    let indexPath = IndexPath(item: currentIndex!, section: 0)
    tableView.reloadRows(at: [indexPath], with: .automatic)
>>>>>>> eventcreation3
  }
  
  // Location Field
  func textInputCell2(textInputCell2: TextInputCell2, locationInputStarted location: String) {
<<<<<<< HEAD
    self.performSegue(withIdentifier: "locationSelectionSegue", sender: self)
    currentIndex = 2
  }
  
  func textInputCell2(textInputCell2: TextInputCell2, locationInputSelected location: String) {
    
  }
  
  // Start Date Field
  func textInputCell2(textInputCell2: TextInputCell2, startDateTimeStarted row: Int) {
    currentIndex  = 3
  }
  
  func textInputCell2(textInputCell2: TextInputCell2, startDateTimeSelected row: Int) {
    
  }
  
  // End Date Field
  func textInputCell2(textInputCell2: TextInputCell2, endDateTimeStarted row: Int) {
    currentIndex = 4
  }
  
  func textInputCell2(textInputCell2: TextInputCell2, endDateTimeSelected row: Int) {
    
=======
    currentIndex = 2
    if !locationSelected {
      self.performSegue(withIdentifier: "locationSelectionSegue", sender: self)
    }
  }
  
  // Start Date Field
  func textInputCell2(textInputCell2: TextInputCell2, startDateTimeStarted row: Int) {
    currentIndex  = 3
    locationSelected = false
  }
  
  // End Date Field
  func textInputCell2(textInputCell2: TextInputCell2, endDateTimeStarted row: Int) {
    currentIndex = 4
    locationSelected = false
>>>>>>> eventcreation3
  }
}
