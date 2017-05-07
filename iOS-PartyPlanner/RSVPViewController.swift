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
  
  
  var rsvpResponse: RsvpResponse = .notResponded
  /*
   var id: String
   var eventId: String
   var guestEmail: String
   // the number of persons coming with the guest
   var guestPlusX: Int = 0
   var response: RsvpResponse? = .notResponded
   var ref: FIRDatabaseReference?
   var key: String?

   */
  
  
  
  @IBAction func sendRSVP(_ sender: Any) {
    RSVP.currentInstance?.guestEmail = (User.currentUser?.email)!
    RSVP.currentInstance?.guestPlusX = guestCount
    RSVP.currentInstance?.response = rsvpResponse
    RSVP.currentInstance?.id = (RSVP.currentInstance?.eventId)! + (User.currentUser?.uid)!
    RsvpApi.sharedInstance.storeRsvp(rsvp: RSVP.currentInstance!)
    performSegue(withIdentifier: "RSVPToHomeSegue", sender: self)
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
    
    let uuid = UUID().uuidString
    let name = "Birthday bash " + uuid
    let testEvent = Event(id: uuid, invitationVideoURL: "", name: name, dateTime: Date(), tagline: "Test event", hostEmail: "u2@userr.com", guestEmailList: ["una.020@gmail.com","una.020@gmail.com"], location: "somewhere", inviteMediaUrl: "http://wallpaper-gallery.net/images/party-images/party-images-15.jpg", inviteMediaType: .image, postEventImages: [], postEventVideos: [], likesCount: 0, postEventCommentIdList: [])
    
    EventApi.sharedInstance.storeEvent(event: testEvent)
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
