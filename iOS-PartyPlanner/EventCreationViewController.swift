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
  
  // toolbars
  var datepicker = UIDatePicker()
  var toolbar = UIToolbar()
  
  fileprivate var event: Event!

  // current states
  fileprivate var currentIndex: Int!
  fileprivate var eventStartDateTime: Date!
  fileprivate var eventEndDateTime: Date!
  fileprivate var eventName: String?
  fileprivate var eventTaskCount: Int = 0
  fileprivate var eventGuestList: [String] = []
  fileprivate var locationSelected = false
  fileprivate var location: String?
  
  // image/video
  fileprivate var eventImage: UIImage?
  
  //Event host profileImage
  var eventHostProfileImage: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    eventHostProfileImage = User.currentUser?.imageUrl
    
    tableView.delegate = self
    tableView.dataSource = self
    
    event = Event()
    prepareToolBars()
    
    // initially set the event start time as currrent time and
    // end time an hour later

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
    if segue.identifier == "EventCreationAddContactSegue" {
      let vc = segue.destination as! AddContactsViewController
      vc.delegate = self
    }
    if segue.identifier == "EventCreationAddTaskSegue" {
      let vc = segue.destination as! TasksViewController
      vc.isNewevent = true
      vc.event = event
      vc.delegate = self
    }
  }
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
      if eventImage != nil {
        cell.myImageView.image = eventImage
      } else {
        cell.myImageView.image = #imageLiteral(resourceName: "Theme")
      }
      cell.delegate = self
      return cell
    }
      
    else if indexPath.row == 1 {
      // Event Name label
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      cell.textInput.leftImage = #imageLiteral(resourceName: "Pen")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Event Name"
      if eventName != nil {
        cell.textInput.text = eventName
      }
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
    else if indexPath.row == 5 {
      // Add Guests
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      cell.textInput.leftImage = #imageLiteral(resourceName: "TimerComplete")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Add guests for the event"
      cell.indexRow = indexPath.row
      cell.textInput.isUserInteractionEnabled = false
      cell.textInput.text = "\(eventGuestList.count) guests added"
      cell.delegate = self
      return cell
    }
    else if indexPath.row == 6 {
      // Add Tasks
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      cell.textInput.leftImage = #imageLiteral(resourceName: "TimerComplete")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Add tasks"
      cell.indexRow = indexPath.row
      cell.textInput.isUserInteractionEnabled = false
      cell.textInput.text = "\(eventTaskCount) tasks added"
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
  func prepareToolBars() {
    toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerValueChanged))
    toolbar.setItems([doneButton], animated: true)
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
    } else if currentIndex == 4 {
      // end time selected
      eventEndDateTime = datetime
      let indexPath = IndexPath(item: currentIndex!, section: 0)
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
  }
}
// MARK: - Media Selection delegates and methods
extension EventCreationViewController: ImageCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  func imageCell(imageCell: ImageCell, media: String) {
    let alert = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
      self.openCamera()
    }))
    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
      self.openGallery()
    }))
    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func openCamera() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = .camera
      picker.mediaTypes = ["public.image", "public.movie"]
      present(picker, animated: true) { }
    } else {
      let cameraPermissionDisabled = UIAlertController(title: "You have disabled camera permissions. Please enable the camera permissions in your phone settings!", message: nil, preferredStyle: .alert)
      cameraPermissionDisabled.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
      self.present(cameraPermissionDisabled, animated: true, completion: nil)
      openGallery()
    }
  }
  
  func openGallery() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    picker.mediaTypes = ["public.image", "public.movie"]
    picker.videoMaximumDuration = 45.0
    picker.videoQuality = .typeMedium
    self.present(picker, animated: true,completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    // If selected Media is Image
    if info[UIImagePickerControllerMediaType] as! String == "public.image" {
      
      let selectImage = info[UIImagePickerControllerEditedImage] as? UIImage
      //      let image = UIImageJPEGRepresentation(selectImage!, 0.55)! as NSData
      eventImage = selectImage
      let indexpath = IndexPath(item: 0, section: 0)
      tableView.reloadRows(at: [indexpath], with: .fade)
    }
    // video
    //    else if info["UIImagePickerControllerMediaType"] as! String == "public.movie" {
    //
    //      selectedVideoUrl = info[UIImagePickerControllerMediaURL] as? URL
    //      print(selectedVideoUrl ?? "URL could not be fetched")
    //      video = NSData(contentsOf: selectedVideoUrl!)
    //      mediaDisplayView.image = Utils.previewImageFromVideo(selectedVideoUrl!)!
    //        }
    //    mediaDisplayView.contentMode = .scaleAspectFit
    dismiss(animated: true) {}
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true) {}
  }
}

// MARK: - TextInputCell delegates
extension EventCreationViewController: TextInputCell2Delegate {
  
  // Event Name filed
  func textInputCell2(textInputCell2: TextInputCell2, eventNameEntered eventName: String) {
    currentIndex = 1
    locationSelected = false
    
    self.eventName = eventName
    let indexPath = IndexPath(item: currentIndex!, section: 0)
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
  // Location Field
  func textInputCell2(textInputCell2: TextInputCell2, locationInputStarted location: String) {
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
  }
}

// MARK: - Task creation and contact selection delegates
extension EventCreationViewController: TasksViewControllerDelegate, AddContactsViewControllerDelegate {
  
  func addContactsViewController(addContactsViewController: AddContactsViewController, contactsAdded: [String]) {
    let newGuestList = eventGuestList + contactsAdded
    eventGuestList = Array(Set(newGuestList))
    let indexPath = IndexPath(item: 5, section: 0)
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
  func tasksViewController(tasksViewController: TasksViewController,  count: Int) {
    if count > 0 {
      eventTaskCount = count
      let indexPath = IndexPath(item: 6, section: 0)
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
  }
  
}
