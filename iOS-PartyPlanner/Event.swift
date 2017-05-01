import UIKit

class Event: NSObject {
    var invitationVideoURL:URL = URL(string: "http://devstreaming.apple.com/videos/wwdc/2016/204t23fvanrkj7a1oj7/204/hls_vod_mvp.m3u8")!
    
    var name: String = "Party planner on-line celebration"
    
    var id: String?
    
    var tagline: String? = "Hello every one"
    
    var date: Date? = Date()
    
    var host: User?
    
    var location: String? = "2535 Garcia Ave, Mountain View, CA"
    
    var rsvpList: [RSVP]?
    
    var taskList: [Task]?
    
    var itemList: [Item]?
    
    var inviteImage: URL?
    
    var giftList: [Item]?
    
    var guestList: [User]?
    
    var postEventImages: [URL]? = [URL(string: "https://pbs.twimg.com/profile_images/492764609711853568/tE8mncDj_normal.jpeg")!,
        URL(string: "https://pbs.twimg.com/profile_images/3733911236/2020e4bb6c39a3848d5a030f20d367ba_normal.jpeg")!,
        URL(string: "https://pbs.twimg.com/profile_images/492764609711853568/tE8mncDj_normal.jpeg")!]
    
    var postEventVideos: [URL]?
    
    var likesCount: String?
    
    var postEventComments: [UserComments]?
}
