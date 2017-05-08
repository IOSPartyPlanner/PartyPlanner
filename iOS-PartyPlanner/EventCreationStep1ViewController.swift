//
//  EventCreationStep1ViewController.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/2/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase


class EventCreationStep1ViewController: UIViewController {
  
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var mediaDisplayView: UIImageView!
  
  @IBOutlet weak var eventNameTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var startDateTimeTextField: UITextField!
  @IBOutlet weak var endDateTimeTextField: UITextField!
  
  let datepicker = UIDatePicker()
  var currentDateFieldSelected: UITextField!
  
  //media
  var video: NSData?
  var selectedVideoUrl: URL?
  var image: NSData?
  var uploadMediaType: MediaType?
  var uploadMediaUrl: String?
  var uploadMediaFilePath: String?
  
  // schedule DateTime
  var startDateTime: Date!
  var endDateTime: Date!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createDatepicker()
    
    eventNameTextField.delegate = self
    locationTextField.delegate = self
    startDateTimeTextField.delegate = self
    endDateTimeTextField.delegate = self
    endDateTimeTextField.isEnabled = false
    mediaDisplayView.layer.cornerRadius = 8
  }
  
  // Mark: - Date Selection
  func createDatepicker() {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerValueChanged))
    toolbar.setItems([doneButton], animated: true)
    
    startDateTimeTextField.inputAccessoryView = toolbar
    endDateTimeTextField.inputAccessoryView = toolbar
    
    startDateTimeTextField.inputView = datepicker
    endDateTimeTextField.inputView = datepicker
  }
  
  @IBAction func onStartDateTime(_ sender: UITextField) {
    scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
    currentDateFieldSelected = startDateTimeTextField
  }
  
  @IBAction func onEndDateTime(_ sender: UITextField) {
    scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
    currentDateFieldSelected = endDateTimeTextField
  }
  
  func datePickerValueChanged(sender: Any) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeStyle = DateFormatter.Style.medium
    
    if currentDateFieldSelected == startDateTimeTextField {
      // check if date is set in past
      if Utils.isDateTimePast(date: datepicker.date) {
        let eventStartDateCannotBeInPast = UIAlertController(title: "Event start date cannot be in past!", message: nil, preferredStyle: .alert)
        eventStartDateCannotBeInPast.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(eventStartDateCannotBeInPast, animated: true, completion: nil)
      } else {
        startDateTime = datepicker.date
        // enable end date selection only when start date is set
        endDateTimeTextField.isEnabled = true
        
        currentDateFieldSelected.text = Utils.getShortTimeStampStringFromDate(date: datepicker.date)
        currentDateFieldSelected.resignFirstResponder()
      }
    } else if currentDateFieldSelected == endDateTimeTextField {
      // check if end date before the event start date
      if startDateTime > datepicker.date {
        let eventCannotEndBeforeStartAlert = UIAlertController(title: "Event cannot end before it starts!", message: nil, preferredStyle: .alert)
        eventCannotEndBeforeStartAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(eventCannotEndBeforeStartAlert, animated: true, completion: nil)
      } else {
        endDateTime = datepicker.date
        currentDateFieldSelected.text = Utils.getShortTimeStampStringFromDate(date: datepicker.date)
        currentDateFieldSelected.resignFirstResponder()
      }
    }
    
    
  }
  
}


extension EventCreationStep1ViewController {
  
  
}

// MARK: - Keyboard and UITextField
// Methods that listen to TextField editing and move UI
// when keyboard is shown
extension EventCreationStep1ViewController: UITextFieldDelegate{
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == eventNameTextField {
      scrollView.setContentOffset(CGPoint(x: 0, y: 60), animated: true)
    }
    if textField == locationTextField {
      scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    scrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}

// MARK: - Media selection
extension EventCreationStep1ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  @IBAction func onCameraButton(_ sender: Any) {
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
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .camera
    picker.mediaTypes = ["public.image", "public.movie"]
    present(picker, animated: true) { }
    
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
      image = UIImageJPEGRepresentation(selectImage!, 0.55)! as NSData
      mediaDisplayView.image = selectImage
      
      // TODO: Compress image before uploading
      // imageURL = UIImageJPEGRepresentation(mediaDisplayView.image!, 0.5) as! NSData
      
      //      MediaApi.sharedInstance.uploadMediaToFireBase (
      //        mediaUrl: imageUrl!,
      //        type: .image, filepath: uploadMediaFilePath!,
      //        success: {uploadMediaUrl in
      //
      //        self.uploadMediaUrl = uploadMediaUrl
      //        print("Image Uploaded2")
      //        self.mediaDisplayView.contentMode = .scaleAspectFit
      //        self.dismiss(animated: true) {}
      //
      //      }, failure: {
      //        print("\nEvent Creation 1 UIController :: Error Uploading Image!\n")
      //      })
      
      // If selected Media is Video
    } else if info["UIImagePickerControllerMediaType"] as! String == "public.movie" {
      
      selectedVideoUrl = info[UIImagePickerControllerMediaURL] as? URL
      print(selectedVideoUrl ?? "URL could not be fetched")
      video = NSData(contentsOf: selectedVideoUrl!)
      mediaDisplayView.image = Utils.previewImageFromVideo(selectedVideoUrl!)!
      
      //      MediaApi.sharedInstance.uploadMediaToFireBase (
      //        mediaUrl: videoUrl!,
      //        type: .video, filepath: uploadMediaFilePath!,
      //        success: {uploadMediaUrl in
      //
      //          print("Video Uploaded2")
      //          self.uploadMediaUrl = uploadMediaUrl
      //          self.dismiss(animated: true) {}
      //
      //      }, failure: {
      //        print("\nEvent Creation 1 UIController : Error Uploading Video!\n")
      //      })
    }
    mediaDisplayView.contentMode = .scaleAspectFit
    dismiss(animated: true) {}
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true) {}
  }
  
  @IBAction func onMediaTapGesture(_ sender: UITapGestureRecognizer) {
    print("Playing Video")
    
    if let videoUrl = selectedVideoUrl{
      
      let player = AVPlayer(url: videoUrl)
      let playerViewController = AVPlayerViewController()
      playerViewController.player = player
      
      present(playerViewController, animated: true){
        playerViewController.player!.play()
      }
    }
  }
}
