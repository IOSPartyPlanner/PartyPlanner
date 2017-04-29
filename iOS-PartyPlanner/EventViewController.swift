//
//  EventViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var eventTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventTableView.delegate = self
        eventTableView.dataSource = self
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "EventSummaryTableViewCell", for: indexPath) as? EventSummaryTableViewCell
        //cell?.event = APIClient.sharedInstance.fecthEvent(byId: "")
        return cell!
    }
}
