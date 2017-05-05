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
  @IBOutlet weak var addImageButton: UIButton!
  @IBOutlet weak var mediaDisplayView: UIImageView!
  
  var videoUrl: URL?
  var image: NSData?
  var video: URL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Media selection
  
  @IBAction func onCameraButton(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .camera
    picker.mediaTypes = ["public.image", "public.movie"]
    
    present(picker, animated: true) { }
  }
  
  @IBAction func onAddImageButton(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    picker.mediaTypes = ["public.image", "public.movie"]
    
    self.present(picker, animated: true,completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if info[UIImagePickerControllerMediaType] as! String == "public.image" {
      
      mediaDisplayView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
      image = UIImageJPEGRepresentation(mediaDisplayView.image!, 0.5) as! NSData
//      image = UIImagePNGRepresentation() as! NSData //, 0.8)! as NSData
      
      uploadImageToFireBase(success: {
        print("Image Uploaded2")
        self.mediaDisplayView.contentMode = .scaleAspectFit
        self.dismiss(animated: true) {}
      }, failure: {
        print("Error Uploading Image!")
      })
      
    } else if info["UIImagePickerControllerMediaType"] as! String == "public.movie" {
      
      videoUrl = info[UIImagePickerControllerMediaURL] as? URL
      print(videoUrl ?? "URL could not be fetched")
      mediaDisplayView.image = previewImageFromVideo(videoUrl!)!
      uploadVideoToFireBase(success: {
        print("Video Uploaded2")
        self.dismiss(animated: true) {}
      }, failure: {
        print("Error Uploading Image!")
      })
    }
    
    
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true) {}
  }
  
  @IBAction func onMediaTapGesture(_ sender: UITapGestureRecognizer) {
    print("Playing Video")
    
    if let videoUrl = videoUrl{
      
      let player = AVPlayer(url: videoUrl)
      
      let playerViewController = AVPlayerViewController()
      playerViewController.player = player
      
      present(playerViewController, animated: true){
        playerViewController.player!.play()
      }
    }
  }
  
  func uploadVideoToFireBase(success: @escaping () -> (), failure: @escaping () -> ())
  {
    let storageRef = FIRStorage.storage().reference()
    let filePath = "EventMedia/event001/eventvideo1.mov"
    let mediaStorageRef = storageRef.child("media")
    
    let metadata = FIRStorageMetadata()
//    metadata.contentType = "image/jpg"
    
    let videoRef = mediaStorageRef.child(filePath)
    
    FIRAuth.auth()?.signIn(withEmail: "u3@gmail.com", password: "qwerty", completion: {
      (user: FIRUser?, error: Error?) in
      if error != nil {
        print("UNable to login")
      } else {
        print("successful login")
        _ = videoRef.putFile(self.videoUrl!,
                             metadata: nil,
                             completion: { (metadata, error) in
          if error != nil {
            print("Error Uploading Video!:: \(error?.localizedDescription ?? "oops error")")
            return
          } else {
            print("Video Uploaded!")
            print(metadata)
            let downloadURL = metadata?.downloadURL
            print(downloadURL)
            success()
          }
        })
      }
    })
  }
  
  func uploadImageToFireBase(success: @escaping () -> (), failure: @escaping () -> ())
  {
    let storageRef = FIRStorage.storage().reference()
    let filePath = "EventMedia/event001/eventImage1.jpg"
    let mediaStorageRef = storageRef.child("media")
    
    let metadata = FIRStorageMetadata()
    metadata.contentType = "image/jpg"
    
    let imageRef = mediaStorageRef.child(filePath)
    
    FIRAuth.auth()?.signIn(withEmail: "u3@gmail.com", password: "qwerty", completion: {
      (user: FIRUser?, error: Error?) in
      if error != nil {
        print("UNable to login")
      } else {
        print("successful login")
        _ = imageRef.put(self.image! as Data, metadata: metadata, completion: { (metadataRes, error) in
          
          if error != nil {
            print("Error Uploading Image!:: \(error?.localizedDescription ?? "oops error")")
            return
          } else {
            print("Image Uploaded!")
            print(metadataRes)
            let downloadURL = metadata.downloadURL
            print(downloadURL)
            success()
          }
        })
      }
    })
  }
  
  
  func previewImageFromVideo(_ url:URL) -> UIImage? {
    let asset = AVAsset(url:url)
    let imageGenerator = AVAssetImageGenerator(asset:asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    var time = asset.duration
    time.value = min(time.value,2)
    
    do {
      let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
      return UIImage(cgImage: imageRef)
    } catch {
      return nil
    }
  }
}
