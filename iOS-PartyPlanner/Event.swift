import UIKit
import Firebase

// Mark:- Enum
enum MediaType: String {
  case image
  case video
}

public class Event: NSObject {
  
  let fireBaseRef = FIRDatabase.database().reference(withPath: "event")
//  
//  var invitationVideoURL: String?
  
  var id: String
  
  var name: String?
  
  var detail: String?
  
  var dateTime: Date
  
  var peroid: TimeInterval?
  
  var tagline: String?
  
  var hostEmail: String
  
  var hostProfileImage : String?
  
  var guestEmailList: [String]?
  
  var location: String?
  
  var inviteMediaUrl: String?
  
  var inviteMediaType: MediaType?
  
  var postEventImages: [String]?
  
  var postEventVideos: [String]?
  
  var postEventPhotoesURL: [URL]?
  
  var likesCount: Int?
  
  var ref: FIRDatabaseReference?
  
  var key: String?
  
  var response : String?
  
  var guests: [User] = []
  
  var postComments: [Comment] = []
  
  var tasks: [Task] = []
    
  var qcode: String?
  
  override init() {
    id = Utils.generateUUID()
    dateTime = Date.init()
    hostEmail = (User.currentUser?.email) ?? "dummy user" // TODO: remove dummy user
  }
  
  //TODO: Need to add detail field to event table in Friebase
  init(id: String, /*invitationVideoURL:String?, */ name: String?,
       dateTime: Date, tagline: String, hostEmail: String, guestEmailList: [String],
       location: String, inviteMediaUrl: String,
       inviteMediaType: MediaType, postEventImages: [String], postEventVideos: [String],
       likesCount: Int) {
    
    self.id = id
//    self.invitationVideoURL = "http://devstreaming.apple.com/videos/wwdc/2016/204t23fvanrkj7a1oj7/204/hls_vod_mvp.m3u8"
    self.name = name ?? "Party planner on-line celebration"
    self.dateTime = dateTime
    self.tagline = tagline
    self.hostEmail = hostEmail
    self.guestEmailList = guestEmailList
    self.location = location
    self.inviteMediaUrl = inviteMediaUrl
    self.inviteMediaType = inviteMediaType
    self.postEventImages = postEventImages
    self.postEventVideos = postEventVideos
    self.likesCount = likesCount
    self.ref = ref ?? nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
//    invitationVideoURL = snapshotValue["invitationVideoURL"] as? String
    name = snapshotValue["name"] as? String
    dateTime = Utils.getTimeStampFromString(timeStampString: snapshotValue["dateTime"] as! String)
    tagline = snapshotValue["tagline"] as? String
    hostEmail = snapshotValue["hostEmail"] as! String
    guestEmailList = snapshotValue["guestEmailList"] as? [String] ?? []
    location = snapshotValue["location"] as! String
    inviteMediaUrl = snapshotValue["inviteImageUrl"] as? String
    inviteMediaType = MediaType(rawValue: snapshotValue["inviteMediaType"] as! String)!
    postEventImages = snapshotValue["postEventImages"] as? [String] ?? []
    postEventVideos = snapshotValue["postEventVideos"] as? [String] ?? []
    likesCount = snapshotValue["likesCount"] as? Int ?? 0
    qcode = snapshotValue["qcode"] as? String ?? ""
  }
  
  func isUserOnwer() -> Bool {
    return User._currentUser?.email == hostEmail
  }
  
  func isPast() -> Bool {
    return dateTime <= Date()
  }
  
  func toAnyObject() -> Any {
    return [
      "id": id,
//      "invitationVideoURL": invitationVideoURL!,
      "name": name!,
      "dateTime": Utils.getTimeStampStringFromDate(date: dateTime),
      "tagline": tagline,
      "hostEmail": hostEmail,
      "guestEmailList": guestEmailList,
      "location": location,
      "inviteImageUrl": inviteMediaUrl,
      "inviteMediaType" : inviteMediaType!.rawValue,
      "postEventImages": postEventImages,
      "postEventVideos": postEventVideos,
      "qcode": qcode,
      "likesCount": likesCount
    ]
  }
  
  func fecthRelateData() {
    guests.removeAll()
    guestEmailList?.forEach{UserApi.sharedInstance.getUserByEmail(userEmail: $0, success: { (user) in
      self.guests.append(user!)
    }, failure: {})
    }
    
    CommentApi.sharedInstance.getCommentsByEventId(eventId: id, success: { comments in
        self.postComments = comments
        comments.forEach{comment in
            UserApi.sharedInstance.getUserByEmail(userEmail: comment.userEmail, success: { (user) in
                comment.userImageURL = URL(string: (user?.imageUrl)!)
            }, failure: {})
        }
    }, failure: {})
    
    TaskApi.sharedInstance.getTasksByEventId(eventId: id, success: { (tasks) in
      self.tasks = tasks
    }, failure: {})
    
    postEventPhotoesURL = postEventImages?.map{
      return URL(string: $0)!
    }
  }
  
}
