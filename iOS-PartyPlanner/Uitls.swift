//
//  Uitls.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/29/17.

//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class Utils: NSObject {
  
  private static var formatter = DateFormatter()
  
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
    formatter.dateFormat = "EEE MMM d hh:mm a"
    return formatter.date(from: timeStampString)!
  }
  
  static func getShortTimeStampStringFromDate(date: Date) -> String {
    formatter.dateFormat = "EEE MMM d hh:mm a"
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
    
  static func formatCircleImage(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
  }
  
  // Mark : -- Media
  
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
  
  static func generateUUID() -> String {
    return UUID().uuidString
  }
  
  
  // proj theme color hex = "DD5521"
  static func getProjThemeUIColor() -> UIColor {
    return UIColorFromHex(rgbValue: 0xDD5521)
  }
  
  private static func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
  }
  
  static func getTextFieldFontBig() -> UIFont{
    return UIFont(name: "HelveticaNeue-Thin" , size: 30)!
  }
}
