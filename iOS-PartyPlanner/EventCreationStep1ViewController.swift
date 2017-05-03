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

class EventCreationStep1ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var addImageButton: UIButton!
  @IBOutlet weak var mediaDisplayView: UIImageView!
  
  var videoUrl: URL?
  
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
    picker.sourceType = .photoLibrary
    picker.mediaTypes = ["public.image", "public.movie"]
    
    present(picker, animated: true) { }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    print(info["UIImagePickerControllerMediaType"] as! String)
    if info["UIImagePickerControllerMediaType"] as! String == "public.image" {
      
      mediaDisplayView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
      
    } else if info["UIImagePickerControllerMediaType"] as! String == "public.movie" {
      
      videoUrl = info["UIImagePickerControllerReferenceURL"] as? URL
      print(videoUrl ?? "URL could not be fetched")
      mediaDisplayView.image = previewImageFromVideo(videoUrl!)!
      
    }
    
    mediaDisplayView.contentMode = .scaleAspectFit
    dismiss(animated: true) {}
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
