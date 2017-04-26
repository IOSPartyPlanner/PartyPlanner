import UIKit 

class Event: NSObject {
  var invitationURL:URL = URL(string: "https://www.youtube.com/embed/tsCn7PI8Jro")!
    
  var name: String = "Party planner on-line celebration"
  
  var id: String?
  
  var tagline: String?
  
  var host: User?
  
  var location: String?
  
  var rsvpList: [Rsvp]?
  
  var taskList: [Task]?
  
  var itemList: [Item]?
  
  var inviteImage: Image?
  
  var inviteVideo: Video?
  
  var giftList: [Gift]?
  
  var postEventImages: [Image]?
  
  var postEventVideos: [Video]?
  
  var likesCount: String?
  
  var postEventComments: [String]?
}
