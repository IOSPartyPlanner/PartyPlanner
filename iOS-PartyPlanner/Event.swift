import UIKit
import Firebase

public class Event: NSObject {
  
  let fireBaseRef = FIRDatabase.database().reference(withPath: "event")
  
  var invitationVideoURL: URL?
  var name: String?
  var id: String
  var dateTime: Date
  var tagline: String
  var hostId: String
  var location: String
  var rsvpIdList: [String]
  var taskIdList: [String]
  var itemIdList: [String]
  var inviteImageUrl: URL
  var giftIdList: [String]
  var postEventImages: [URL]
  var postEventVideos: [URL]
  var likesCount: Int
  var postEventCommentIdList: [String]
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(invitationVideoURL:URL?, name: String?, id: String,
       dateTime: Date, tagline: String, hostId: String,
       location: String,
       rsvpIdList: [String], taskIdList: [String],
       itemIdList: [String],
       inviteImageUrl: URL,
       giftIdList: [String],
       postEventImages: [URL], postEventVideos: [URL],
       likesCount: Int, postEventCommentIdList: [String]) {
    
    self.invitationVideoURL = invitationVideoURL ?? URL(string: "http://devstreaming.apple.com/videos/wwdc/2016/204t23fvanrkj7a1oj7/204/hls_vod_mvp.m3u8")
    self.name = name ?? "Party planner on-line celebration"
    self.id = id
    self.dateTime = dateTime
    self.tagline = tagline
    self.hostId = hostId
    self.location = location
    self.rsvpIdList = rsvpIdList
    self.taskIdList = taskIdList
    self.itemIdList = itemIdList
    self.inviteImageUrl = inviteImageUrl
    self.giftIdList = giftIdList
    self.postEventImages = []
    self.postEventVideos = []
    self.likesCount = likesCount
    self.postEventCommentIdList = []
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
    dateTime = Utils.getTimeStampFromString(timeStampString: snapshotValue["dateTime"] as! String)
    tagline = snapshotValue["tagline"] as! String
    hostId = snapshotValue["hostId"] as! String
    location = snapshotValue["location"] as! String
    rsvpIdList = snapshotValue["rsvpIdList"] as! [String]
    taskIdList = snapshotValue["taskIdList"] as! [String]
    itemIdList = snapshotValue["itemIdList"] as! [String]
    inviteImageUrl = snapshotValue["inviteImage"] as! URL
    giftIdList = snapshotValue["giftIdList"] as! [String]
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
      "hostId": hostId,
      "location": location,
      "rsvpIdList": rsvpIdList,
      "taskIdList": taskIdList,
      "itemIdList": itemIdList,
      "inviteImageUrl": inviteImageUrl.absoluteString,
      "giftIdList": giftIdList,
      "postEventImages": postEventImages,
      "postEventVideos": postEventVideos,
      "likesCount": likesCount,
      "postEventCommentIdList": postEventCommentIdList
    ]
  }
  
}
