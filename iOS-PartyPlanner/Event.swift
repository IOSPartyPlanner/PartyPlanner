import UIKit 

class Event: NSObject {
  var invitationVideoURL:URL = URL(string: "http://devstreaming.apple.com/videos/wwdc/2016/204t23fvanrkj7a1oj7/204/hls_vod_mvp.m3u8")!
    
  var name: String = "Party planner on-line celebration"
  
  var id: String?
  
  var tagline: String?
  
  var host: User?
  
  var location: String?
  
  var rsvpList: [RSVP]?
  
  var taskList: [Task]?
  
  var itemList: [Item]?
  
  var inviteImage: URL?
  
  var giftList: [Item]?
  
  var postEventImages: [URL]?
  
  var postEventVideos: [URL]?
  
  var likesCount: String?
  
  var postEventComments: [String]?
}
