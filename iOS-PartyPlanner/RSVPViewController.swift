//
//  RSVPViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import DLRadioButton

class RSVPViewController: UIViewController{

  @IBOutlet weak var yesButton: DLRadioButton!
  @IBOutlet weak var maybeButton: DLRadioButton!
  @IBOutlet weak var noButton: DLRadioButton!
  @IBOutlet weak var guestCounter: UISegmentedControl!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var sendButton: UIButton!
  
  
  var rsvpResponse: RsvpResponse = .notResponded
  var guestUser: User?
  
  @IBAction func sendRSVP(_ sender: Any) {
    RSVP.currentInstance?.guestPlusX = guestCount
    RSVP.currentInstance?.response = rsvpResponse
    if RSVP.currentInstance?.id == nil {
      RSVP.currentInstance?.id = (RSVP.currentInstance?.eventId)! + (RSVP.currentInstance?.guestEmail)!.replacingOccurrences(of: ".", with: "")
    }
    RsvpApi.sharedInstance.storeRsvp(rsvp: RSVP.currentInstance!)
    performSegue(withIdentifier: "RSVPToHomeSegue", sender: self)
    RSVP.currentInstance = nil
  }
  
  @IBAction func onGuestCounter(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex{
    case 0: print("decrement")
    if guestCount > 0 {
        guestCount = guestCount-1
      }
    default: print("increment")
      guestCount = guestCount+1
    }
//    sender.subviews[sender.selectedSegmentIndex-1].backgroundColor = UIColor.black
//    sender.subviews[sender.selectedSegmentIndex-1].tintColor = UIColor.white
    sender.selectedSegmentIndex = -1
        print(guestCount)
    
    if guestCount >= 0 {
      DispatchQueue.main.async() {
        self.countLabel.text = String(describing: self.guestCount) + "(+ you)"
      }
    }

  }
  
    var guestCount:Int = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      yesButton.otherButtons = [maybeButton, noButton]
      
      yesButton.addTarget(self, action: #selector(logSelectedButton(radioButton:)), for: UIControlEvents.touchDown)
      noButton.addTarget(self, action: #selector(logSelectedButton(radioButton:)), for: UIControlEvents.touchDown)
      maybeButton.addTarget(self, action: #selector(logSelectedButton(radioButton:)), for: UIControlEvents.touchDown)
      
      let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 20.0)!, forKey: NSFontAttributeName as NSCopying)
      UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
      
      guestCounter.isHidden = true
      countLabel.isHidden = true
      
      /*UserApi.sharedInstance.getUserByEmail(userEmail: (RSVP.currentInstance?.guestEmail)!, success: { (user) in
        self.guestUser = user
      }) {
        print("Failed to fetch user by email in rsvp")
      }*/
      
      sendButton.layer.cornerRadius = 10
      sendButton.layer.borderWidth = 1
      sendButton.layer.borderColor = UIColor.black.cgColor
      sendButton.roundedButton()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  @objc func logSelectedButton(radioButton:DLRadioButton){
    let response:String = (radioButton.titleLabel?.text)!
    print ("\(response) is selected.")
    if response == "Yes" {
      countLabel.isHidden = false
      guestCounter.isHidden = false
      rsvpResponse = .yes
    }
    else {
      guestCounter.isHidden = true
      countLabel.isHidden = true
      guestCount = 0
      if (response == "No") {
        rsvpResponse = .no
      }
      if (response == "Maybe"){
        rsvpResponse = .maybe
      }
    }
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
