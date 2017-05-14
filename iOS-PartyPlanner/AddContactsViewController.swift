//
//  AddContactsViewController.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/11/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import Lottie

@objc protocol AddContactsViewControllerDelegate {
  @objc optional func addContactsViewController(addContactsViewController: AddContactsViewController, contactsAdded emails: [String])
}

class AddContactsViewController: UIViewController {
  
  fileprivate var addedEmails: Set<String> = []
  fileprivate let contacts = [ ["name": "Tristan",  "email": "tristan.yim@gmail.com"],
                               ["name": "Rabia",    "email":  "tgcksr@gmail.com"],
                               ["name": "Anusha",   "email": "una.020@gmail.com"],
                               ["name": "Bharath",  "email":  "bharathmh@gmail.com"] ]
  
  @IBOutlet weak var tableView: UITableView!
  weak var delegate: AddContactsViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
  }
  
  override func viewWillDisappear(_ animated: Bool) {
  }
  
  @IBAction func onCancel(_ sender: Any) {
    let animationView = LOTAnimationView(name: "spacehub")
    animationView?.frame = view.bounds
    animationView?.contentMode = .scaleAspectFit
    animationView?.animationSpeed = 4
    self.view.addSubview(animationView!)
    
    animationView?.play(completion: { finished in
      self.navigationController?.popViewController(animated: true)
    })
  }
  
  @IBAction func onSaveButton(_ sender: Any) {
    let animationView = LOTAnimationView(name: "simple_check")
    animationView?.frame = view.bounds
    animationView?.contentMode = .scaleAspectFit
    animationView?.animationSpeed = 4
    self.view.addSubview(animationView!)
    
    animationView?.play(completion: { finished in
      self.delegate?.addContactsViewController!(addContactsViewController: self, contactsAdded: Array(self.addedEmails))
      self.navigationController?.popViewController(animated: true)
    })
  }
  
}

// Mark: - TableView
extension AddContactsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contactSelectionCell", for: indexPath) as! ContactSelectionCell
    cell.nameLabel?.text = "\(contacts[indexPath.row]["name"]!)"
    cell.emailLabel?.text = "\(contacts[indexPath.row]["email"]!)"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? ContactSelectionCell else { return }
    addedEmails.insert(cell.emailLabel.text!)
    toggleCellCheckbox(cell)
  }
  
  func toggleCellCheckbox(_ cell: ContactSelectionCell) {
    UIView.animate(withDuration: 0.23) {
      cell.accessoryType = .checkmark
      cell.nameLabel?.textColor = UIColor.gray
      cell.emailLabel?.textColor = UIColor.gray
    }
  }
}
