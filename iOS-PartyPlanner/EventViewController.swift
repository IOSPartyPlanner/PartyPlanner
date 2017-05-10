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
        
        //TODO: There is no fetchEvent in the APIClient
        //event = APIClient.sharedInstance.fecthEvent(byId: "")        
        eventTableView.rowHeight = UITableViewAutomaticDimension
        eventTableView.estimatedRowHeight = 120
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
            case 0, 1, 3:
                return 1
            case 2:
                return event?.tasks!.count ?? 0
            default:
                return event?.postComments!.count ?? 0
            }
        } else {
            switch section {
            case 0, 1:
                return 1
            default:
                return event?.postEventCommentIdList!.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (event?.isUserOnwer())! {
            if section == 1 {
                return "Guests"
            } else {
                return "Tasks"
            }
        } else {
            if section == 3 {
                return "Media"
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, (event?.isUserOnwer())!) {
        case (0, _):
            let cell0 = eventTableView.dequeueReusableCell(withIdentifier: "EventSummaryTableViewCell", for: indexPath) as? EventSummaryTableViewCell
            cell0?.event = event
            return cell0!
        case (1, true):
            let cell1 = eventTableView.dequeueReusableCell(withIdentifier: "EventGuestsTableViewCell", for: indexPath) as? EventGuestsTableViewCell
            cell1?.guests = event?.guests
            cell1?.viewController = self
            return cell1!
        case (2, true):
            let cell2 = eventTableView.dequeueReusableCell(withIdentifier: "EventTasksTableViewCell", for: indexPath) as? EventTasksTableViewCell
//            cell2?.photoes = event?.postEventImages
//            cell1?.viewController = self
            return cell2!
        case (1, false),
             (3, true):
                let cell3 = eventTableView.dequeueReusableCell(withIdentifier: "PhotoesTableViewCell", for: indexPath) as? PhotoesTableViewCell
                cell3?.photoes = event?.postEventImages
                cell3?.viewController = self
                return cell3!
        default:
            let cell4 = eventTableView.dequeueReusableCell(withIdentifier: "EventGuestCommentTableViewCell", for: indexPath) as? EventGuestCommentTableViewCell
            if let userComment = event?.postComments?[indexPath.row] {
                cell4?.comment = userComment
            }
            return cell4!
        }

    }
}
