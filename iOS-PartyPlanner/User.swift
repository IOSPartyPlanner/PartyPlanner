import UIKit
import Firebase

// Mark:- Enum
enum AuthenticationType: String {
  case PartyPlanner = "PartyPlanner"
  case Google =  "Google"
  case Facebook = "Facebook"
//  case Twitter
}

// Mark:- User Class
class User: NSObject {
    
  let fireBaseRef = FIRDatabase.database().reference(withPath: "user")

  var name: String
  var email: String?
  var phone: String?
  var imageUrl: URL?
  var authType:String?
  var uid: String
  var ref: FIRDatabaseReference?
  var key: String?
  
  static var logout: Notification = Notification(name: Notification.Name(rawValue: "UserLogOut"))

  
  init(name: String,
       email: String?, phone: String? = nil,
       imageUrl: URL?, authType: String? = AuthenticationType.PartyPlanner.rawValue,
       uid: String, ref: FIRDatabaseReference? = nil) {
    self.name = name
    self.email = email
    self.phone = phone
    self.imageUrl = imageUrl
    self.authType = authType
    self.uid = uid
    self.ref = ref ?? nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    name = snapshotValue["name"] as! String
    email = snapshotValue["email"] as? String
    phone = snapshotValue["phone"] as? String
    imageUrl = URL(string: snapshotValue["imageUrl"] as! String)!
    authType = snapshotValue["authType"] as? String
    uid = snapshotValue["uid"] as! String
  }
  
  func toAnyObject() -> Any {
    return [
      "name": name,
      "email": email,
      "imageUrl": imageUrl!.absoluteString,
      "uid": uid,
      "authType": authType
    ]
  }

  static var _currentUser: User?
  static var currentUser : User? {
    get {
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: "currentUserData") as? Data
        if userData != nil {
          let dictionary = try!
            JSONSerialization.jsonObject(with: userData!, options: []) as! NSDictionary
          
          print(dictionary)
          _currentUser = User(name: dictionary["name"] as! String, email: dictionary["email"] as? String, imageUrl: URL(string: dictionary["imageUrl"] as! String), authType: dictionary["authType"] as? String, uid: dictionary["uid"] as! String)
          //User(name: dictionary["name"] as! String, email: dictionary["email"] as? String, imageUrl: URL(url: dictionary["imageUrl"]) as? URL, uid: dictionary["uid"] as! String)
//              print("Getting currentuser", _currentUser?.name)
          print(dictionary["name"] as! String, " ", dictionary["email"] as! String)

        }
      }
      
      return _currentUser
    }
    
    
    set(user) {
      
      let defaults = UserDefaults.standard
      
      if user != nil {
        let userDictionary: [String:String] = ["name": (user?.name)!, "email": (user?.email)!, "imageUrl": (user?.imageUrl?.absoluteString)!, "uid": (user?.uid)!, "authType": (user?.authType!)!]

        let data = try! JSONSerialization.data(withJSONObject: userDictionary as Any, options: [])
        defaults.set(data, forKey: "currentUserData")
      }
      else {
        defaults.removeObject(forKey: "currentUserData")
        
      }
      defaults.synchronize()
      
      print("Setting currentuser")
    }
  }
  
  func signout(){
    User.currentUser = nil
    NotificationCenter.default.post(User.logout)
  }

}
