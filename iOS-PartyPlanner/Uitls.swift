//
//  Uitls.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/29/17.

//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class Utils: NSObject {
  
  private static var formatter = DateFormatter()
  
  // Mark: - Date Time related
  static func getTimeStampFromString(timeStampString: String) -> Date {
    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    return formatter.date(from: timeStampString)!
  }
  
  static func getTimeStampStringFromDate(date: Date) -> String {
    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    return formatter.string(from: date)
  }
  
  // The following two functions don't inlcude 
  // seconds and timezone info
  static func getShortTimeStampFromString(timeStampString: String) -> Date {
    formatter.dateFormat = "EEE MMM d HH:mm"
    return formatter.date(from: timeStampString)!
  }
  
  static func getShortTimeStampStringFromDate(date: Date) -> String {
    formatter.dateFormat = "EEE MMM d HH:mm"
    return formatter.string(from: date)
  }
  
  static func isDateTimePast(date: Date) -> Bool {
    if date.timeIntervalSinceNow < 0 {
      return true
    }
    return false
  }
  
  static func isDateTimeFuture(date: Date) -> Bool {
    if date.timeIntervalSinceNow > 0 {
      return true
    }
    return false
  }
  
    
  static func doCircleImage(image: UIImageView) -> UIImageView {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        return image
  }
  
  static func getImageFromUrl(_ url: URL) -> UIImage? {
    var image: UIImage?
    let data = NSData(contentsOf: url)
    if data != nil {
      image = UIImage(data: data! as Data)
    } else {
      return nil
    }
    
    return image
  }
  
  static func previewImageFromVideo(_ url: URL) -> UIImage? {
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
