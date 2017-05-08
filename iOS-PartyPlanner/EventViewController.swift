//
//  EventViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBAction func onSignout(_ sender: UIBarButtonItem) {
        User.currentUser?.signout()
    }
    
    @IBOutlet weak var eventTableView: UITableView!
  
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        eventTableView.rowHeight = UITableViewAutomaticDimension
        eventTableView.estimatedRowHeight = 120
        //TODO: There is no fetchEvent in the APIClient
        //event = APIClient.sharedInstance.fecthEvent(byId: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if (event?.isUserOnwer())! {
            return 5
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (event?.isUserOnwer())! {
            switch section {
            case 0..<4:
                return 1
            default:
                return event?.postEventCommentIdList!.count ?? 0
            }
        } else {
            switch section {
            case 0..<2:
                return 1
            default:
                return event?.postEventCommentIdList!.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, (event?.isUserOnwer())!) {
        case (0, _):
            let cell0 = eventTableView.dequeueReusableCell(withIdentifier: "EventSummaryTableViewCell", for: indexPath) as? EventSummaryTableViewCell
            cell0?.event = event
            return cell0!
        case (1, true):
            let cell1 = eventTableView.dequeueReusableCell(withIdentifier: "PhotoesTableViewCell", for: indexPath) as? PhotoesTableViewCell
            cell1?.photoes = event?.postEventImages
            cell1?.viewController = self
            return cell1!
        case (2, true):
            let cell1 = eventTableView.dequeueReusableCell(withIdentifier: "PhotoesTableViewCell", for: indexPath) as? PhotoesTableViewCell
            cell1?.photoes = event?.postEventImages
            cell1?.viewController = self
            return cell1!
        case (1, false),
             (3, true):
                let cell3 = eventTableView.dequeueReusableCell(withIdentifier: "PhotoesTableViewCell", for: indexPath) as? PhotoesTableViewCell
                cell3?.photoes = event?.postEventImages
                cell3?.viewController = self
                return cell3!
        default:
            let cell4 = eventTableView.dequeueReusableCell(withIdentifier: "EventGuestCommentTableViewCell", for: indexPath) as? EventGuestCommentTableViewCell
//            if let userComment = event?.postEventCommentIdList?[indexPath.row] {
//                cell4?.comments = userComment
//            }
            return cell4!
        }

    }
}
