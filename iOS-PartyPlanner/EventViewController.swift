//
//  EventViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import ELCImagePickerController
import AddressBookUI

class EventViewController: UIViewController {
    
    @IBAction func onSignout(_ sender: UIBarButtonItem) {
        User.currentUser?.signout()
    }
    
    @IBOutlet weak var eventTableView: UITableView!
    
    var event: Event?
    
    var guestsCell: EventGuestsTableViewCell?
    
    let photoesPicker = ELCImagePickerController()
    
    let pickerController = ABPeoplePickerNavigationController()
    
    var qcodeVerificationFailed: Bool?
    
    var guestCollectionView: UICollectionView?
    var photosCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("load event view controller")
        
        // Do any additional setup after loading the view.
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        eventTableView.rowHeight = UITableViewAutomaticDimension
        eventTableView.estimatedRowHeight = 100
        
        eventTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        eventTableView.estimatedSectionHeaderHeight = 100
        
        photoesPicker.imagePickerDelegate = self
        pickerController.peoplePickerDelegate = self
        pickerController.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
        
        if !(event?.isPast())! && (event?.isUserOnwer())! {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "QCode", style: .plain, target: self, action: #selector(generateQCode(_:)))
        }
        //let tableBackgroundView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "eventViewB9"))
        
        //tableBackgroundView.alpha = 1
       // eventTableView.backgroundView = tableBackgroundView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateQCode(_ barItem: UIBarButtonItem) {
        performSegue(withIdentifier: "addInfo", sender: "QCode")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventTableView.reloadData()
        if let qcodeVerificationFailed = qcodeVerificationFailed  {
            if qcodeVerificationFailed {
                let alert = UIAlertController(title: "Passed", message: "You's welcomed to join event \((self.event?.name)!).", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Your qcode is not passed the verification, please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            self.qcodeVerificationFailed = nil
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        switch (segue.identifier)! {
        case "addInfo":
            let target = segue.destination as? AddInfoViewController
            target?.type = sender as! String
            target?.event = event
            switch (target?.type)! {
            case "Comment":
                break
            case "QCode":
                break
            case "Task":
                break
            default:
                break
            }
        case "showQCode":
            let target = segue.destination as? QCodeViewController
            target?.event = event
        default:
            break
        }
    }
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
        //        if (event?.isPast())! || (event?.isUserOnwer())! {
        //            return 3
        //        } else {
        //            return 1
        //        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1,3:
            return 1
        case 2:
             return event?.tasks.count ?? 0
    
        default:
            return event?.postComments.count ?? 0
            /*if (event?.isPast())! {
                return event?.postComments.count ?? 0
            } else {
                return event?.tasks.count ?? 0
            }*/
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 1.0
        default:
            return 40.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "HeadAddTableViewCell") as? HeadAddTableViewCell
        cell?.viewController = self
        /*cell?.layer.borderWidth = 0.5
        cell?.layer.borderColor = UIColor.red.cgColor
        cell?.layer.cornerRadius = 3*/

        switch section {
        case 1:
            //if (event?.isPast())! {
            
            //} else {
                cell?.titleLabel.text = "Guests"
                let gesture = UITapGestureRecognizer(target: self, action: #selector(addGuests(_:)))
                cell?.addImageView.addGestureRecognizer(gesture)
                if !(event?.isUserOnwer())! {
                    cell?.addImageView.isHidden = true
                }
            //}
        case 2:
            
           // if (event?.isPast())! {
           // } else {
                cell?.titleLabel.text = "Tasks"
                let gesture = UITapGestureRecognizer(target: self, action: #selector(addTask(_:)))
                cell?.addImageView.addGestureRecognizer(gesture)
                if !(event?.isUserOnwer())! {
                    cell?.addImageView.isHidden = true
                }
           // }
        case 3:
            cell?.titleLabel.text = "Media"
            let gesture = UITapGestureRecognizer(target: self, action: #selector(addPhotoes(_:)))
            cell?.addImageView.addGestureRecognizer(gesture)
            /*if !(event?.isUserOnwer())! {
                cell?.addImageView.isHidden = true
            }*/
        case 4:
            cell?.titleLabel.text = "Comments"
            let gesture = UITapGestureRecognizer(target: self, action: #selector(addComment(_:)))
            cell?.addImageView.addGestureRecognizer(gesture)
            
        default:
            return nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
           // if (event?.isPast())! {
            
            //} else {
                return "Guests"
           // }
        case 2:
           // if (event?.isPast())! {
            //} else {
                return "Tasks"
            //}
        case 3:
             return "Photos"
        case 4:
              return "Comments"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, (event?.isPast())!) {
        case (0, _):
            let cell0 = eventTableView.dequeueReusableCell(withIdentifier: "EventSummaryTableViewCell", for: indexPath) as? EventSummaryTableViewCell
            cell0?.event = event
            cell0?.viewController = self
            cell0?.backgroundColor = UIColor(white: 1, alpha: 0.6)
            return cell0!
        case (1, _):
            guestsCell = eventTableView.dequeueReusableCell(withIdentifier: "EventGuestsTableViewCell", for: indexPath) as? EventGuestsTableViewCell
            guestsCell?.event = event
            guestsCell?.viewController = self
            guestsCell?.backgroundColor = UIColor(white: 1, alpha: 0.6)
            guestCollectionView = guestsCell?.guestCollectionView
            return guestsCell!
        case (3, _):
            let cell1 = eventTableView.dequeueReusableCell(withIdentifier: "PhotoesTableViewCell", for: indexPath) as? PhotoesTableViewCell
               cell1?.photoes = event?.postEventImages
           
            cell1?.viewController = self
            cell1?.backgroundColor = UIColor(white: 1, alpha: 0.6)
            photosCollectionView = cell1?.photoesCollectionView
            return cell1!
        case (2, _):
            let cell2 = eventTableView.dequeueReusableCell(withIdentifier: "EventTasksTableViewCell", for: indexPath) as? EventTasksTableViewCell
            let task = event?.tasks[indexPath.row]
            if task?.volunteerEmails == nil || task?.volunteerEmails?.count == 0 {
                cell2?.taskImageView.image = UIImage(named: "assigning")
                cell2?.taskImageView.isUserInteractionEnabled = true
                let gesture = UITapGestureRecognizer(target: self, action: #selector(assignToMe(_:)))
                cell2?.addGestureRecognizer(gesture)
            } else {
                cell2?.taskImageView.image = UIImage(named: "assigned")
            }
            cell2?.taskImageView.translatesAutoresizingMaskIntoConstraints = true
            
            //TODO:Ask cell2?.taskDescLabel.text = task?.description
            
        
            cell2?.taskNameLabel.text = task?.name
            cell2?.backgroundColor = UIColor(white: 1, alpha: 0.6)
            return cell2!
        default:
            let cell2 = eventTableView.dequeueReusableCell(withIdentifier: "EventGuestCommentTableViewCell", for: indexPath) as? EventGuestCommentTableViewCell
            if let userComment = event?.postComments[indexPath.row] {
                userComment.userName = User.currentUser?.name
                cell2?.comment = userComment
            }
            cell2?.backgroundColor = UIColor(white: 1, alpha: 0.6)
            return cell2!
        }
        
    }
    
    func assignToMe(_ sender: UITapGestureRecognizer) {
        let cell = sender.view as? EventTasksTableViewCell
        let indexPath = eventTableView.indexPath(for: cell!)
        if let task = event?.tasks[(indexPath?.row)!] {
            TaskApi.sharedInstance.addVolunteer(emails: [(User._currentUser?.email)!], taskId: task.id)
            cell?.taskImageView.image = UIImage(named: "assigned")
        }
        
    }
    
    func addPhotoes(_ sender: UITapGestureRecognizer) {
        navigationController?.present(photoesPicker, animated: true, completion: nil)
    }
    
    func addGuests(_ sender: UITapGestureRecognizer) {
        navigationController?.present(pickerController, animated: true, completion: nil)
    }
    
    func addComment(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "addInfo", sender: "Comment")
    }
    
    func addTask(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "addInfo", sender: "Task")
    }
}


extension EventViewController: ELCImagePickerControllerDelegate {
    func elcImagePickerController(_ picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [Any]!) {
        print(info)
        let images = info as? [NSDictionary]
        for line in images! {
            let mediaURL = line["UIImagePickerControllerReferenceURL"] as? URL
            let assets = PHAsset.fetchAssets(withALAssetURLs: [mediaURL!], options: nil)
            let asset = assets.firstObject
            PHImageManager.default().requestImageData(for: asset!, options: nil, resultHandler: { (data, _, _, _) in
                let imageName = UUID().uuidString + ".jpeg"
                let assetUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageName)
                do {
                    try data?.write(to: assetUrl, options: .atomic)
                    MediaApi.sharedInstance.uploadMediaToFireBase(mediaUrl: assetUrl, type: .image, filepath: "\((self.event?.id)!)/\(imageName)", success: { (url) in
                        EventApi.sharedInstance.addPhotoURL(url, withEvent: self.event!)
                        self.event?.postEventImages?.append(url)
                        self.photosCollectionView?.reloadData()
                    }, failure: {})
                } catch {
                }
            })
        }
        dismiss(animated: true, completion: nil)
    }
    /**
     * Called when image selection was cancelled, by tapping the 'Cancel' BarButtonItem.
     */
    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EventViewController: ABPeoplePickerNavigationControllerDelegate {
    
    func peoplePickerNavigationControllerDidCancel(_ peoplePicker: ABPeoplePickerNavigationController) {
        dismiss(animated: true, completion: nil)
    }
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        
        let emails = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue()  as ABMultiValue
        let emailIds = ABMultiValueCopyArrayOfAllValues(emails).takeUnretainedValue() as! [String]
        if emailIds.count > 0 {
            EventApi.sharedInstance.addGuestEmail(emailIds.first!, withEvent: event!)
            UserApi.sharedInstance.getUserByEmail(userEmail: emailIds.first!, success: { (user) in
                self.event?.guests.append(user!)
                self.guestCollectionView?.reloadData()
            }, failure: {})
        }
        
        dismiss(animated: true, completion: nil)
    }
}

