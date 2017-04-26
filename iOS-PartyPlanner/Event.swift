import UIKit 

class Event: NSObject {
  var invitationVideoURL:URL = URL(string: "https://www.youtube.com/embed/tsCn7PI8Jro")!
    
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
