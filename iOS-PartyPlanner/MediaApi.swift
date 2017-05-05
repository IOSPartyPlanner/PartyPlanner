//
//  MediaApi.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/4/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation
import Firebase

class MediaApi: NSObject {
  
  static let sharedInstance = MediaApi()
  private let mediaStorageRef = FIRStorage.storage().reference().child("media")
  
  func uploadVideoToFireBase(mediaUrl: URL, success: @escaping () -> (), failure: @escaping () -> ())
  {
    
    let filePath = "EventMedia/event001/eventvideo1.mov"
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
}

