import UIKit
import Firebase

// Mark:- Enum
enum AuthenticationType: String {
  case PartyPlanner
  case Google
  case Facebook
//  case Twitter
}

// Mark:- User Class
class User: NSObject {
  let fireBaseRef = FIRDatabase.database().reference(withPath: "user")

  var name: String
  var email: String
  var phone: String
  var imageUrl: URL
  var authType: AuthenticationType = .PartyPlanner
  var uid: String
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(name: String,
       email: String, phone: String,
       address: String, imageUrl: URL,
       authType: AuthenticationType, uid: String,
       ref: FIRDatabaseReference?) {
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
    email = snapshotValue["email"] as! String
    phone = snapshotValue["phone"] as! String
    imageUrl = URL(string: snapshotValue["imageUrl"] as! String)!
    authType = AuthenticationType(rawValue: snapshotValue["authType"] as! String)!
    uid = snapshotValue["uid"] as! String
  }
  
  func toAnyObject() -> Any {
    return [
      "name": name,
      "email": email,
      "phone": phone,
      "imageUrl": imageUrl.absoluteString,
      "uid": uid,
      "authType": authType.rawValue
    ]
  }
}
