import UIKit
import Firebase

class Event: NSObject {
  
  var invitationVideoURL: URL?
  var name: String?
  var id: String
  var dateTime: Date
  var tagline: String
  var host: User
  var location: String
  var rsvpList: [RSVP]
  var taskList: [Task]
  var itemList: [Item]
  var inviteImageUrl: URL
  var giftList: [Item]
  var postEventImages: [URL]
  var postEventVideos: [URL]
  var likesCount: Int
  var postEventComments: [Comment]
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(invitationVideoURL:URL?, name: String?, id: String,
       dateTime: Date, tagline: String, host: User,
       location: String, rsvpList: [RSVP], taskList: [Task],
       itemList: [Item], inviteImageUrl: URL, giftList: [Item],
       postEventImages: [URL], postEventVideos: [URL],
       likesCount: String, postEventComments: [String]) {
    
    self.invitationVideoURL = invitationVideoURL ?? URL(string: "http://devstreaming.apple.com/videos/wwdc/2016/204t23fvanrkj7a1oj7/204/hls_vod_mvp.m3u8")
    self.name = name ?? "Party planner on-line celebration"
    self.id = id
    self.dateTime = dateTime
    self.tagline = tagline
    self.host = host
    self.location = location
    self.rsvpList = rsvpList
    self.taskList = taskList
    self.itemList = itemList
    self.inviteImageUrl = inviteImageUrl
    self.giftList = giftList
    self.postEventImages = []
    self.postEventVideos = []
    self.likesCount = 0
    self.postEventComments = []
    self.ref = ref ?? nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    invitationVideoURL = snapshotValue["invitationVideoURL"] as? URL
    name = snapshotValue["name"] as? String
    id = snapshotValue["id"] as! String
    dateTime = snapshotValue["dateTime"] as! Date
    tagline = snapshotValue["tagline"] as! String
    host = snapshotValue["host"] as! User
    location = snapshotValue["location"] as! String
    rsvpList = snapshotValue["rsvpList"] as! [RSVP]
    taskList = snapshotValue["taskList"] as! [Task]
    itemList = snapshotValue["itemList"] as! [Item]
    inviteImageUrl = snapshotValue["inviteImage"] as! URL
    giftList = snapshotValue["giftList"] as! [Item]
    postEventImages = snapshotValue["postEventImages"] as! [URL]
    postEventVideos = snapshotValue["postEventVideos"] as! [URL]
    likesCount = snapshotValue["likesCount"] as! Int
    postEventComments = snapshotValue["postEventComments"] as! [Comment]
  }
  
  func toAnyObject() -> Any {
    return [
      
      "id": id,
      "invitationVideoURL": invitationVideoURL!,
      "name": name!,
      "id": id,
      "dateTime": dateTime,
      "tagline": tagline,
      "host": host,
      "location": location,
      "rsvpList": rsvpList,
      "taskList": taskList,
      "itemList": itemList,
      "inviteImage": inviteImageUrl,
      "giftList": giftList,
      "postEventImages": postEventImages,
      "postEventVideos": postEventVideos,
      "likesCount": likesCount,
      "postEventComments": postEventComments
    ]
  }

  
  
}
