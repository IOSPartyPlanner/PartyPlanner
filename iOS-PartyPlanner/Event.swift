import UIKit
import Firebase

// Mark:- Enum
enum MediaType: String {
  case image
  case video
}

public class Event: NSObject {
  
  let fireBaseRef = FIRDatabase.database().reference(withPath: "event")
  
  var invitationVideoURL: URL?
  var id: String
  var name: String?
  var dateTime: Date
  var tagline: String
  var hostEmail: String
  var location: String
  var inviteMediaUrl: URL
  var inviteMediaType: MediaType
  var postEventImages: [URL]
  var postEventVideos: [URL]
  var likesCount: Int
  var postEventCommentIdList: [String]
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, invitationVideoURL:URL?, name: String?,
       dateTime: Date, tagline: String, hostEmail: String,
       location: String, inviteMediaUrl: URL,
       inviteMediaType: MediaType, postEventImages: [URL], postEventVideos: [URL],
       likesCount: Int, postEventCommentIdList: [String]) {
    
    self.id = id
    self.invitationVideoURL = invitationVideoURL ?? URL(string: "http://devstreaming.apple.com/videos/wwdc/2016/204t23fvanrkj7a1oj7/204/hls_vod_mvp.m3u8")
    self.name = name ?? "Party planner on-line celebration"
    self.dateTime = dateTime
    self.tagline = tagline
    self.hostEmail = hostEmail
    self.location = location
    self.inviteMediaUrl = inviteMediaUrl
    self.inviteMediaType = inviteMediaType
    self.postEventImages = postEventImages
    self.postEventVideos = postEventVideos
    self.likesCount = likesCount
    self.postEventCommentIdList = postEventCommentIdList
    self.ref = ref ?? nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    invitationVideoURL = snapshotValue["invitationVideoURL"] as? URL
    name = snapshotValue["name"] as? String
    dateTime = Utils.getTimeStampFromString(timeStampString: snapshotValue["dateTime"] as! String)
    tagline = snapshotValue["tagline"] as! String
    hostEmail = snapshotValue["hostEmail"] as! String
    location = snapshotValue["location"] as! String
    inviteMediaUrl = snapshotValue["inviteMediaUrl"] as! URL
    inviteMediaType = MediaType(rawValue: snapshotValue["inviteMediaType"] as! String)!
    postEventImages = snapshotValue["postEventImages"] as! [URL]
    postEventVideos = snapshotValue["postEventVideos"] as! [URL]
    likesCount = snapshotValue["likesCount"] as! Int
    postEventCommentIdList = snapshotValue["postEventCommentIdList"] as! [String]
  }
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "invitationVideoURL": invitationVideoURL!.absoluteString,
      "name": name!,
      "dateTime": Utils.getTimeStampStringFromDate(date: dateTime),
      "tagline": tagline,
      "hostEmail": hostEmail,
      "location": location,
      "inviteImageUrl": inviteMediaUrl.absoluteString,
      "inviteMediaType" : inviteMediaType.rawValue,
      "postEventImages": postEventImages,
      "postEventVideos": postEventVideos,
      "likesCount": likesCount,
      "postEventCommentIdList": postEventCommentIdList
    ]
  }
  
}
