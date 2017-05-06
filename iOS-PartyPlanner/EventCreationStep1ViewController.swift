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


class EventCreationStep1ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var mediaDisplayView: UIImageView!
  @IBOutlet weak var eventNameTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  
  var video: NSData?
  var selectedVideoUrl: URL?
  var image: NSData?
  
  var uploadMediaType: MediaType?
  var uploadMediaUrl: String?
  var uploadMediaFilePath: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mediaDisplayView.layer.cornerRadius = 8
  }
  
  // MARK: - Media selection
  
  @IBAction func onCameraButton(_ sender: Any) {
    //    buttonEdit.setTitleColor(UIColor.white, for: .normal)
    //    buttonEdit.isUserInteractionEnabled = true
    
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
      
      let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
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
  
  
  @IBAction func onTestPastEvent(_ sender: Any) {
    
  }
  
  
  
}
