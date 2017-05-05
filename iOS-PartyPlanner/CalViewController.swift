//
//  CalViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 5/3/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class CalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createEvent(_ sender: Any) {
        let api = CalendarAPI()
        api.createPartyEvent(event: nil)
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
