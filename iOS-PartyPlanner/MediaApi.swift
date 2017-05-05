//
//  MediaApi.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/4/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

// Mark:- Enum
import Foundation
import Firebase

class MediaApi: NSObject {
  
  static let sharedInstance = MediaApi()
  private let mediaStorageRef = FIRStorage.storage().reference().child("media")
  
  func uploadVideoToFireBase(mediaUrl: URL, type: MediaType, success: @escaping () -> (), failure: @escaping () -> ())
  {
    var filePath: String!
    if type == .image {
      filePath = "EventMedia/event001/image1.jpg"
    } else if type == .video {
      filePath = "EventMedia/event001/eventvideo1.mov"
    }
    
    let mediaRef = mediaStorageRef.child(filePath)
    
    FIRAuth.auth()?.signIn(withEmail: "u3@gmail.com", password: "qwerty", completion: {
      (user: FIRUser?, error: Error?) in
      if error != nil {
        print("UNable to login")
      } else {
        print("successful login")
        _ = mediaRef.putFile(mediaUrl,
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
}

