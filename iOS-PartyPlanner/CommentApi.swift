//
//  CommentApi.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/30/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation
import Firebase

@objc protocol CommentApiDelegate {
  @objc optional func commentApi(userApi: CommentApi, commentUpdated comment: Comment)
}

class CommentApi: NSObject {
  
  static let sharedInstance = CommentApi()
  private let fireBaseCommentRef = FIRDatabase.database().reference(withPath: "comment")
  weak var delegate: CommentApiDelegate?
  
  func storeComment(comment: Comment) {
    print("CommentApi : Storing/updating comment")
    let commentRef = fireBaseCommentRef.child(comment.id)
    commentRef.setValue(comment.toAnyObject())
    delegate?.commentApi!(userApi: self, commentUpdated: comment)
  }
  
  func getCommentById(commentId: String, success: @escaping (Comment?) ->(), failure: @escaping () -> ()) {
    print("CommentApi : searching for Comment by id \(commentId)")
    var comment: Comment?
    fireBaseCommentRef.queryOrdered(byChild: "id")
      .queryEqual(toValue: commentId)
      .observe(.value, with: { snapshot in
        for commentChild in snapshot.children {
          comment = Comment(snapshot: commentChild as! FIRDataSnapshot)
          break
        }
        
        if comment == nil {
          failure()
        } else {
          success(comment)
        }
      })
  }
  
  func getCommentsByEventId(eventId: String, success: @escaping ([Comment]?) ->(), failure: @escaping () -> ()) {
    print("CommentApi : searching Comments by eventid \(eventId)")
    var comments: [Comment]?
    fireBaseCommentRef.queryOrdered(byChild: "eventId")
      .queryEqual(toValue: eventId)
      .observe(.value, with: { snapshot in
        for commentChild in snapshot.children {
          let comment = Comment(snapshot: commentChild as! FIRDataSnapshot)
          comments?.append(comment)
        }
        
        if comments == nil {
          failure()
        } else {
          success(comments)
        }
      })
  }
  
}
