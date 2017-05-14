//
//  EventDetailViewController.swift
//  iOS-PartyPlanner
//
//  Created by Tuze on 4/30/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userCityLabel: UILabel!
    @IBOutlet var firstGuestProfileImage: UIImageView!
    @IBOutlet var secondGuestProfileImage: UIImageView!
    @IBOutlet var thirdGuestProfileImage: UIImageView!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var eventPlaceLabel: UILabel!
    @IBOutlet var eventDateTimeLabel: UILabel!
    @IBOutlet var eventDetailsLabel: UILabel!
    @IBOutlet var RSVPButton: UIButton!
    @IBOutlet var tasksButton: UIButton!
    @IBOutlet var giftsButton: UIButton!
    @IBOutlet var addMediaButton: UIButton!
    @IBOutlet var mediaCollectionView: UICollectionView!
    @IBOutlet var commentsTableView: UITableView!
    @IBOutlet var newCommentTextField: UITextField!
    @IBOutlet var sendCommentButton: UIButton!
    
    var postEventImages: [String] = []
    var postEventVideos: [String] = []
    var commentList : [Comment] = []
  
    var  event: Event?{
        didSet {
            
            if let name = event?.name{
                 eventNameLabel.text = name
            }
            
            if let location = event?.location{
                eventPlaceLabel.text = location
            }
            
            if let eventDetail = event?.detail{
                eventPlaceLabel.text = eventDetail
            }
            
            if let dateTime = event?.dateTime{
                eventDateTimeLabel.text = String (describing: dateTime)
            }
            
            if let images = event?.postEventImages {
                postEventImages = images
            }
            
            if let videos = event?.postEventVideos {
                postEventImages = videos
            }
            
            //TODO:Needed guest list
            //First,Second,Third Guest will be assigned here
        
            
            Utils.formatCircleImage(image: userProfileImageView)
            setHostInfo(hostEmail: (event?.hostEmail)!)
            
           
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setHostInfo(hostEmail: String){
        //TODO:Call get user info firebase fuction
    }
    
    func getComments(commentIds : [String]){
        //TODO:Test
        /*for i in 0 ... commentIds.count {
            //commentList.append(CommentApi.getCommentById(commentId: commentIds[i], success: {_ in },failure: {}))
        }*/

     
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postEventImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as! MediaCollectionViewCell
       // cell.mediaImageView.setImage= postEventImages[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        cell.comment = commentList[indexPath.item]
    
        return cell
    }
    
    
    @IBAction func sendNewComment(_ sender: Any) {
    }


}
