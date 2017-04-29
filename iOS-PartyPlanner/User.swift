import UIKit
import Firebase

// Mark:- Enum
enum AuthenticationType: String {
  case PartyPlanner
  case Google
  case Facebook
  case Twitter
}

// Mark:- User Class
class User: NSObject {
  let fireBaseRef = FIRDatabase.database().reference(withPath: "user")

  
  var id: String
  var userName: String
  var passwordHash: String
  var name: String
  var email: String
  var phone: String
  var address: String
  var imageUrl: URL
  var authType: AuthenticationType = .PartyPlanner
  var uid: String
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, userName: String,
       passwordHash: String, name: String,
       email: String, phone: String,
       address: String, imageUrl: URL,
       authType: AuthenticationType, uid: String,
       ref: FIRDatabaseReference?) {
    self.id = id
    self.userName = userName
    self.passwordHash = passwordHash
    self.name = name
    self.email = email
    self.phone = phone
    self.address = address
    self.imageUrl = imageUrl
    self.authType = authType
    self.uid = uid
    self.ref = ref ?? nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    userName = snapshotValue["userName"] as! String
    passwordHash = snapshotValue["passwordHash"] as! String
    name = snapshotValue["name"] as! String
    email = snapshotValue["email"] as! String
    phone = snapshotValue["phone"] as! String
    address = snapshotValue["address"] as! String
    imageUrl = URL(string: snapshotValue["imageUrl"] as! String)!
    authType = AuthenticationType(rawValue: snapshotValue["authType"] as! String)!
    uid = snapshotValue["uid"] as! String
  }
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "userName": userName,
      "passwordHash": passwordHash,
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "imageUrl": imageUrl.path,
      "uid": uid,
      "authType": authType.rawValue
    ]
  }
  
  func getTestUser() -> User {
    let testUser = User(id: "123", userName: "abc", passwordHash: "123456", name: "user1", email: "user1@gmail.com", phone: "1234567890", address: "2750, Coast Ave", imageUrl: URL(string: "http://imgur.com/gallery/2TBP4")!, authType: .PartyPlanner, uid: "12", ref: nil)
    return testUser
  }
  
  
  //Mark:- API
  func storeUser() {
    let userRef = fireBaseRef.child(id)
    userRef.setValue(self.toAnyObject())
  }
  
  
}
