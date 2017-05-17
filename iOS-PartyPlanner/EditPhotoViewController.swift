//
//  EditPhotoViewController.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/8/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import CoreImage;
import CoreGraphics;

@objc protocol EditPhotoViewControllerDelegate {
  @objc optional func editPhotoViewController(editPhotoViewController: EditPhotoViewController, imageSaved image: UIImage)
}


class EditPhotoViewController: UIViewController, UIGestureRecognizerDelegate{
  
  @IBOutlet var sliderContrast: UISlider!
  @IBOutlet var sliderSaturation: UISlider!
  @IBOutlet var sliderBrightness: UISlider!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var adjustColorView: UIView!
  
  @IBOutlet var addStickerButton: UIButton!
  @IBOutlet var adjustColorButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  
  fileprivate var colorControl = ColorControl()
  @IBOutlet var trayView: UIView!
  var trayOriginalCenter: CGPoint!
  var trayCenterWhenOpen : CGPoint!
  var trayCenterWhenClosed : CGPoint!
  var trayDownOffset: CGFloat! = 160
  var newlyCreatedFace: UIImageView!
  var newlyCreatedFaceOriginalCenter: CGPoint!
  var frictionDrag: CGFloat!
  var scale: CGFloat! = 0.5
  var rotation = CGFloat(0)
  
  var image: UIImage?
  weak var delegate: EditPhotoViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if image != nil {
      imageView.image = image
    }
    
    trayOriginalCenter = trayView.center
    trayCenterWhenOpen  = trayView.center
    trayCenterWhenClosed = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)
    frictionDrag = 10
    colorControl.input(imageView.image!)
    self.setUISLidersValues()
    trayView.isHidden = true
    trayView.layer.cornerRadius = 7
    adjustColorView.layer.cornerRadius = 7
    addStickerButton.layer.cornerRadius = 7
    adjustColorButton.layer.cornerRadius = 7
    saveButton.layer.cornerRadius = 7
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func onSaveButton(_ sender: Any) {
    UIView.animate(withDuration: 0.25) {
      self.trayView.alpha = 0
      self.trayView.isHidden = true
      
      self.saveButton.alpha = 0
      self.saveButton.isHidden = true
      
      self.addStickerButton.alpha = 0
      self.addStickerButton.isHidden = true
      
      self.adjustColorButton.alpha = 0
      self.adjustColorButton.isHidden = true
      
      self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    imageView.image = captureView()
    
    UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0);
    self.view.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    delegate?.editPhotoViewController!(editPhotoViewController: self, imageSaved: image)
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    self.navigationController?.popViewController(animated: true)
  }
  
  
  fileprivate func setUISLidersValues() {
    
    sliderSaturation.minimumValue = 0;
    sliderSaturation.maximumValue = 2;
    sliderBrightness.minimumValue = -1;
    sliderBrightness.maximumValue = 1;
    sliderContrast.minimumValue = 0;
    sliderContrast.maximumValue = 4;
    
    sliderSaturation.value = 1;
    sliderBrightness.value = 0;
    sliderContrast.value = 1;
  }
  
  
  @IBAction func addStickerOnClick(_ sender: Any) {
    trayView.isHidden = false
    adjustColorView.isHidden = true
    self.trayView.center = self.trayOriginalCenter
  }
  
  @IBAction func adjustColorOnlick(_ sender: Any) {
    trayView.isHidden = false
    adjustColorView.isHidden = false
    self.trayView.center = self.trayOriginalCenter
  }
  
  
  @IBAction func onEmojiPanGesture(_ sender: UIPanGestureRecognizer) {
    
    let translation = sender.translation(in: view)
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(EditPhotoViewController.didPanNewFace(_:)))
    let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(EditPhotoViewController.didScaleFace(_:)))
    let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(EditPhotoViewController.didRotateNewFace(_:)))
    let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditPhotoViewController.didDoubleTapNewFace(_:)))
    
    panGestureRecognizer.delegate = self
    pinchGestureRecognizer.delegate = self
    rotateGestureRecognizer.delegate = self
    doubleTapGestureRecognizer.numberOfTapsRequired = 2
    doubleTapGestureRecognizer.delegate = self
    
    
    if sender.state == .began {
      
      let imageView = sender.view as! UIImageView
      newlyCreatedFace = UIImageView(image: imageView.image)
      view.addSubview(newlyCreatedFace)
      newlyCreatedFace.center = imageView.center
      newlyCreatedFace.center.y += trayView.frame.origin.y
      newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
      
      newlyCreatedFace.isUserInteractionEnabled = true
      newlyCreatedFace.isMultipleTouchEnabled = true
      newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
      newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
      newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
      newlyCreatedFace.addGestureRecognizer(doubleTapGestureRecognizer)
      
      UIView.animate(withDuration: 0.1, animations: { () -> Void in
        self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
      })
      
      
      newlyCreatedFace.isUserInteractionEnabled = true
      
    } else if sender.state == .changed {
      
      newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
      
    } else if sender.state == .ended {
      
      
      if newlyCreatedFace.center.y >= trayView.frame.origin.y {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
          self.newlyCreatedFace.center = self.newlyCreatedFaceOriginalCenter
          self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (Bool) -> Void in
          self.newlyCreatedFace.removeFromSuperview()
        })
        
      } else {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
          self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
      }
      
    }
  }
  
  @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
    
    let translation = sender.translation(in: view)
    let velocity = sender.velocity(in: view)
    
    if sender.state == .began {
      view.bringSubview(toFront: trayView)
      trayOriginalCenter = trayView.center
      
    } else if sender.state == .changed {
      
      trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
      
    } else if sender.state == .ended {
      
      if velocity.y > 0 {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 20, options: [], animations: { () -> Void in
          self.trayView.center = self.trayCenterWhenClosed
        }, completion: { (Bool) -> Void in
          
        })
        
      } else {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 20, options: [], animations: { () -> Void in
          self.trayView.center = self.trayCenterWhenOpen
        }, completion: { (Bool) -> Void in
          
        })
        
      }
      
    }
  }
  
  func didPanNewFace(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: view)
    
    if sender.state == .began {
      newlyCreatedFace = sender.view as! UIImageView
      newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
      newlyCreatedFace.superview?.bringSubview(toFront: view)
      
      
    } else if sender.state == .changed {
      newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
      
      if newlyCreatedFace.center.y >= trayView.frame.origin.y {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 20, options: [], animations: { () -> Void in
          self.trayView.center = self.trayCenterWhenClosed
        }, completion: { (Bool) -> Void in
          
        })
        
      }
      
    } else if sender.state == .ended {
      
    }
    
  }
  
  func didScaleFace(_ sender: UIPinchGestureRecognizer) {
    scale = sender.scale
    newlyCreatedFace = sender.view as! UIImageView
    newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: scale, y: scale)
    sender.scale = 1
  }
  
  func didRotateNewFace(_ sender: UIRotationGestureRecognizer) {
    rotation = sender.rotation
    newlyCreatedFace = sender.view as! UIImageView
    newlyCreatedFace.transform = newlyCreatedFace.transform.rotated(by: rotation)
    sender.rotation = 0
    
  }
  
  func didDoubleTapNewFace(_ sender: UITapGestureRecognizer) {
    newlyCreatedFace = sender.view as! UIImageView
    newlyCreatedFace.removeFromSuperview()
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

extension EditPhotoViewController {
  @IBAction func contrastControl(_ sender: UISlider) {
    DispatchQueue.main.async {
      self.colorControl.contrast((sender as AnyObject).value)
      self.imageView.image = self.colorControl.outputUIImage()
    }
  }
  
  @IBAction func saturationControl(_ sender: UISlider) {
    DispatchQueue.main.async {
      self.colorControl.saturation((sender as AnyObject).value)
      self.imageView.image = self.colorControl.outputUIImage()
    }
  }
  
  
  @IBAction func brightnessControl(_ sender: UISlider) {
    DispatchQueue.main.async {
      self.colorControl.brightness((sender as AnyObject).value)
      self.imageView.image = self.colorControl.outputUIImage()
    }
    
  }
}
