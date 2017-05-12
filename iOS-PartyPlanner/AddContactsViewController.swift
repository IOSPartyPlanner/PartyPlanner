//
//  AddContactsViewController.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/11/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class AddContactsViewController: UIViewController {
  let contacts = [ ["Tristan": "tristan.yim@gmail.com"],
                   ["Rabia": "tgcksr@gmail.com"],
                   ["Anusha": "una.020@gmail.com"],
                   ["Bharath": "bharathmh@gmail.com"] ]
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  @IBAction func onCancel(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

// Mark: - TableView
extension AddContactsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contactSelectionCell", for: indexPath) as! ContactSelectionCell
    cell.textLabel?.text = "\(contacts[indexPath.row])"
    return cell
  }
}
