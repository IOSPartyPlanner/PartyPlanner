//
//  EditPhotoViewController.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 5/8/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EditPhotoViewController: UIViewController {

    
    @IBOutlet var parentView: UIView!
    @IBOutlet var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen : CGPoint!
    var trayCenterWhenClosed : CGPoint!
    var newlyCreatedFace: UIImageView!
    var faceCenterBeforePan: CGPoint!
    var faceCenterAfterPan: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        trayCenterWhenOpen = parentView.center
        trayCenterWhenClosed = trayView.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onEmojiPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
       // _ = panGestureRecognizer.translation(in: parentView)
        let point = panGestureRecognizer.location(in: parentView)
        
        //let velocity = panGestureRecognizer.velocity(in: parentView)
        if panGestureRecognizer.state == .began {
            let imageView = panGestureRecognizer.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            //            newlyCreatedFace.center.y += trayView.frame.origin.y
        } else if panGestureRecognizer.state == .changed {
            newlyCreatedFace.center = point
            
        } else if panGestureRecognizer.state == .ended {
            
            //            newlyCreatedFace.center = CGPoint(x: newlyCreatedFace.center.x, y:  newlyCreatedFace.center.y + translation.y)
        }
    }
    
    
    
    
    @IBAction func onTrayPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        let point = panGestureRecognizer.location(in: parentView)
      
        let translation = panGestureRecognizer.translation(in: parentView)
        let velocity = panGestureRecognizer.velocity(in: parentView)
        
        if panGestureRecognizer.state == .began {
            trayOriginalCenter = trayView.center
            print("Gesture began at: \(point)")
        } else if panGestureRecognizer.state == .changed {
            
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            print("Gesture changed at: \(trayView.center)")
        } else if panGestureRecognizer.state == .ended {
            if velocity.y > 0 {
                trayView.center = trayCenterWhenClosed
            }
            else{
                trayView.center = trayCenterWhenOpen
            }
            print("Gesture ended at: \(parentView.center)")
        }
    }
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
}
