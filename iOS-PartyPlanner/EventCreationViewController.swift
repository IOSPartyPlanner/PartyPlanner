//
//  EventCreationViewController.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/7/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import Lottie
import Material

class EventCreationViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  // toolbars
  var datepicker = UIDatePicker()
  var toolbar = UIToolbar()
  
  fileprivate var event: Event!
  
  // current states
  fileprivate var currentIndex: Int!
  fileprivate var eventName: String?
  fileprivate var eventDetails: String?
  fileprivate var locationSelected = false
  fileprivate var location: String?
  fileprivate var eventTagline: String?
  fileprivate var eventStartDateTime: Date?
  fileprivate var eventEndDateTime: Date?
  fileprivate var eventGuestList: [String]?
  fileprivate var eventTaskCount: Int?
  fileprivate var eventMediaType: MediaType!
  
  // image/video
  fileprivate var eventImage: UIImage?
  
  // placeholders
  var eventNamePlaceHolder = "Event Name"
  var eventLocationPlaceHodler = "Location"
  var eventStartDatePlaceHolder = "Start Date Time"
  var eventEndDatePlaceHolder = "End Date Time"
  var eventAddGuestPlaceHolder = "Add guests"
  var eventAddTasksPlaceHolder = "Add tasks"
  var eventDetailsPlaceHolder = "Event description"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    event = Event()
    prepareToolBars()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    let imageCellNib = UINib(nibName: "ImageCell", bundle: Bundle.main)
    tableView.register(imageCellNib, forCellReuseIdentifier: "ImageCell")
    
    let inputCellNib = UINib(nibName: "TextInputCell", bundle: Bundle.main)
    tableView.register(inputCellNib, forCellReuseIdentifier: "TextInputCell")
  }
  
  @IBAction func onEventSave(_ sender: Any) {
    validateSaveEvent()
  }
  
  @IBAction func onCancelButton(_ sender: Any) {
    
    let animationView = LOTAnimationView(name: "spacehub")
    animationView?.frame = view.bounds
    animationView?.contentMode = .scaleAspectFit
    animationView?.animationSpeed = 4
    self.view.addSubview(animationView!)
    
    animationView?.play(completion: { finished in
      self.dismiss(animated: true, completion: nil)
    })
  }
  
  
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "EventCreationSelectLocationSegue" {
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


// MARK: - Table
extension EventCreationViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 200
    }
    
    return 60
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Image
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
      
      if eventImage != nil {
        cell.myImageView.image = eventImage
        cell.mediaSelectionButton.alpha = 0.8        
      } else {
        cell.myImageView.image = #imageLiteral(resourceName: "placeholder_orange")
      }
      cell.delegate = self
      return cell
    }
      
    else if indexPath.row == 1 {
      // Event Name label
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      
      let leftView = UIImageView()
      leftView.image = #imageLiteral(resourceName: "pencil")
      cell.textInput.leftView = leftView
      if eventName != nil {
        cell.textInput.text = eventName
      }
      
      cell.textInput.placeholder = eventNamePlaceHolder
      cell.indexRow = indexPath.row
      cell.delegate = self
      return cell
    }
      
    else if indexPath.row == 2 {
      // Location
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      
      let leftView = UIImageView()
      leftView.image = #imageLiteral(resourceName: "location")
      cell.textInput.leftView = leftView
      
      cell.textInput.placeholder = eventLocationPlaceHodler
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
      
      let leftView = UIImageView()
      leftView.image = #imageLiteral(resourceName: "calendar")
      cell.textInput.leftView = leftView
      
      cell.textInput.placeholder = eventStartDatePlaceHolder
      cell.indexRow = indexPath.row
      if eventStartDateTime != nil {
        cell.textInput.text = Utils.getShortTimeStampStringFromDate(date: eventStartDateTime!)
      }
      cell.textInput.inputView = datepicker
      cell.textInput.inputAccessoryView = toolbar
      cell.delegate = self
      return cell
    }
      
    else if indexPath.row == 4 {
      // End Time
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      
      let leftView = UIImageView()
      leftView.image = #imageLiteral(resourceName: "time")
      cell.textInput.leftView = leftView
      
      cell.textInput.placeholder = eventEndDatePlaceHolder
      cell.indexRow = indexPath.row
      if eventEndDateTime != nil {
        cell.textInput.text = Utils.getShortTimeStampStringFromDate(date: eventEndDateTime!)
      }
      cell.textInput.inputView = datepicker
      cell.textInput.inputAccessoryView = toolbar
      cell.delegate = self
      return cell
    }
    else if indexPath.row == 5{
      // Event Name label
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      
      let leftView = UIImageView()
      leftView.image = #imageLiteral(resourceName: "pencil")
      cell.textInput.leftView = leftView
      if self.event.tagline != nil {
        cell.textInput.text = self.event.tagline
      }
      
      cell.textInput.placeholder = eventDetailsPlaceHolder
      cell.indexRow = indexPath.row
      cell.delegate = self
      return cell
    }
    else if indexPath.row == 6 {
      // Add Guests
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      
      let leftView = UIImageView()
      leftView.image =  #imageLiteral(resourceName: "assigning")
      cell.textInput.leftView = leftView
      
      cell.textInput.placeholder = eventAddGuestPlaceHolder
      cell.indexRow = indexPath.row
      cell.textInput.isUserInteractionEnabled = false
      if eventGuestList != nil {
        cell.textInput.text = "\(String(describing: eventGuestList!.count)) guests added"
      }
      cell.delegate = self
      return cell
    }
    else if indexPath.row == 7 {
      // Add Tasks
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell2", for: indexPath) as! TextInputCell2
      
      let leftView = UIImageView()
      leftView.image =  #imageLiteral(resourceName: "todo")
      cell.textInput.leftView = leftView
      
      cell.textInput.placeholder = eventAddTasksPlaceHolder
      cell.indexRow = indexPath.row
      cell.textInput.isUserInteractionEnabled = false
      if eventTaskCount != nil {
        cell.textInput.text = "\(String(describing: eventTaskCount!)) tasks added"
      }
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
    
    if indexPath.row == 6 {
      print("you selected Add Guests")
      self.performSegue(withIdentifier: "EventCreationAddContactSegue", sender: self)
    }
    
    if indexPath.row == 7 {
      print("you selected Add Tasks")
      self.performSegue(withIdentifier: "EventCreationAddTaskSegue", sender: self)
    }
  }
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  tableView.deselectRow(at:indexPath, animated: true)
}

// MARK: - Date and Media Selection
extension EventCreationViewController {
  func prepareToolBars() {
    
    datepicker.backgroundColor = UIColor.white
    datepicker.setValue(Utils.getProjThemeUIColor(), forKeyPath: "textColor")
    datepicker.setValue(0.8, forKeyPath: "alpha")
    
    toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerValueChanged))
    doneButton.tintColor = UIColor.orange
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
extension EventCreationViewController: ImageCellDelegate, UIImagePickerControllerDelegate {
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
      
      let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
      eventImage = selectImage
      eventMediaType = MediaType.image
      let indexpath = IndexPath(item: 0, section: 0)
      tableView.reloadRows(at: [indexpath], with: .fade)
      
      let filePath = "PartyInGoEvent\(self.event.id)/invitation.jpg"
      self.event.inviteMediaType = .image
      
      // upload photos
      // if it's a photo from the library, not an image from the camera
      if #available(iOS 8.0, *), let referenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
        
        let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceUrl], options: nil)
        let asset = assets.firstObject!
        
        PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { (data, _, _, _) in
          let imageName = Utils.generateUUID() + ".jpeg"
          let assetUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageName)
          do {
            try data?.write(to: assetUrl, options: .atomic)
            print("\n Image copied to sandbox successfully")
            MediaApi.sharedInstance.uploadMediaToFireBase(mediaUrl: assetUrl, type: .image, filepath: filePath, success: { (mediaUrl) in
              print(mediaUrl)
              self.event.inviteMediaUrl = mediaUrl
            }, failure: {
              print("Uploading  media failed")
            })
          } catch {
            print("\n error writing media to sandbox!\n")
          }
        })
      }
        // Image from camera
      else {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 0.4) else { return }
        
        MediaApi.sharedInstance.uploadMediaToFireBase(media: imageData, type: MediaType.image, filepath: filePath, success: { (mediaUrl) in
          print(mediaUrl)
          self.event.inviteMediaUrl = mediaUrl
        }, failure: {
          print("Uploading  media failed")
        })
      }
    }
    // if video
    else if info["UIImagePickerControllerMediaType"] as! String == "public.movie" {
      let selectedVideoUrl = info[UIImagePickerControllerMediaURL] as? URL
      print(selectedVideoUrl ?? "URL could not be fetched")
      let video = NSData(contentsOf: selectedVideoUrl!)
      eventImage = Utils.previewImageFromVideo(selectedVideoUrl!)!
      
      eventMediaType = MediaType.video
      let indexpath = IndexPath(item: 0, section: 0)
      tableView.reloadRows(at: [indexpath], with: .fade)
      
      let filePath = "PartyInGoEvent\(self.event.id)/invitation.mov"
      self.event.inviteMediaType = .video
      
      MediaApi.sharedInstance.uploadMediaToFireBase(mediaUrl: selectedVideoUrl!, type: MediaType.video, filepath: filePath, success: { (mediaUrl) in
        self.event.inviteMediaUrl = mediaUrl
      }, failure: {
        print("Uploading  video failed")
      })
    }
    
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
      self.performSegue(withIdentifier: "EventCreationSelectLocationSegue", sender: self)
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
  
  //Event Details
  func textInputCell2(textInputCell2: TextInputCell2, detailsEntered eventDetails: String) {
    currentIndex = 5
    locationSelected = false
    
    self.event.tagline = eventDetails
    let indexPath = IndexPath(item: currentIndex!, section: 0)
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
}

// MARK: - Task creation and contact selection delegates
extension EventCreationViewController: TasksViewControllerDelegate, AddContactsViewControllerDelegate {
  
  func addContactsViewController(addContactsViewController: AddContactsViewController, contactsAdded: [String]) {
    var newGuestList: [String] = []
    if eventGuestList == nil {
      eventGuestList = []
      newGuestList = eventGuestList! + contactsAdded
    }
    newGuestList = eventGuestList! + contactsAdded
    eventGuestList = Array(Set(newGuestList))
    let indexPath = IndexPath(item: 6, section: 0)
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
  func tasksViewController(tasksViewController: TasksViewController,  tasksAddedCount: Int) {
    if tasksAddedCount > 0 {
      eventTaskCount = tasksAddedCount
      let indexPath = IndexPath(item: 7, section: 0)
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
  }
  
}

// MARK: - Location Picker
extension EventCreationViewController: LocationsViewControllerDelegate {
  
  func locationsPickedLocation(controller: LocationsViewController, location: String) {
    locationSelected = true
    print("Address picked was \(location)")
    self.location = location
    let indexpath = IndexPath(item: currentIndex, section: 0)
    tableView.reloadRows(at: [indexpath], with: .automatic)
  }
  
  func locationsPickedLocation(controller: LocationsViewController, cancelled: String) {
    // TODO: This is a temporary fix for location search view showing up after cancel
    locationSelected = true
  }
  
}


extension EventCreationViewController {
  func validateSaveEvent() {
    // check image
    if self.event.inviteMediaUrl == nil {
      displayDisapperaingAlert("Add an image to your party")
      return
    }
    // check name
    if eventName == nil {
      displayDisapperaingAlert("oops! you forgot to name your event")
      return
    } else {
      event.name = eventName
    }
    
    // check location
    if location == nil {
      displayDisapperaingAlert("Event location cannot be empty")
      return
    } else {
      event.location = location
    }
    
    // check start date < check end date
    if Utils.isDateTimePast(date: eventStartDateTime!) {
      displayDisapperaingAlert("Event start date cannot be in the past!!!")
      return
    } else {
      event.dateTime = eventStartDateTime!
    }
    
    if (eventEndDateTime! < eventStartDateTime!) ||  Utils.isDateTimePast(date: eventEndDateTime!) {
      displayDisapperaingAlert("Event cannot end before beginning")
      return
    } else {
      event.peroid = eventEndDateTime?.timeIntervalSince(eventEndDateTime!)
    }
    
    // check guests
    if (eventGuestList?.count)! <= 0 {
      displayDisapperaingAlert("You forgot to invite friends and family")
      return
    } else {
      event.guestEmailList = eventGuestList
    }
    
    // if checks pass, store event
    let animationView = LOTAnimationView(name: "splashy_loader")
    animationView?.frame = self.view.bounds
    animationView?.contentMode = .scaleToFill
    animationView?.animationSpeed = 1
    self.view.addSubview(animationView!)
    
    animationView?.play(completion: { finished in
      self.event.hostEmail = (User.currentUser?.email)!
      self.event.hostProfileImageUrl = User.currentUser?.imageUrl
      self.event.postEventImages = []
      self.event.postEventVideos = []
      self.event.likesCount = 0
      
      EventApi.sharedInstance.storeEvent(event: self.event)
      self.dismiss(animated: true, completion: nil)
    })
  }
  
  func displayDisapperaingAlert(_ message: String) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
    self.present(alert, animated: true, completion: nil)
    
    // change to desired number of seconds (in this case 5 seconds)
    let when = DispatchTime.now() + 2
    DispatchQueue.main.asyncAfter(deadline: when){
      alert.dismiss(animated: true, completion: nil)
    }
  }
}
