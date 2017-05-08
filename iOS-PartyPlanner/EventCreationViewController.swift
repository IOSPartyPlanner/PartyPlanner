//
//  EventCreationViewController.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/7/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EventCreationViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    let imageCellNib = UINib(nibName: "ImageCell", bundle: Bundle.main)
    tableView.register(imageCellNib, forCellReuseIdentifier: "ImageCell")
    
    let inputCellNib = UINib(nibName: "TextInputCell", bundle: Bundle.main)
    tableView.register(inputCellNib, forCellReuseIdentifier: "TextInputCell")
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

// MARK: - Table
extension EventCreationViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    print("\n textFieldDidBeginEditing \n")
  }
}

// MARK: - Table
extension EventCreationViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Image
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
      cell.myImageView.image = #imageLiteral(resourceName: "Theme")
      return cell
    }
      
    else if indexPath.row == 1 {
      // Event Name label
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell", for: indexPath) as! TextInputCell
      cell.textInput.leftImage = #imageLiteral(resourceName: "Pen")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Event Name"
      return cell
    }
    
    else if indexPath.row == 2 {
      // Location
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell", for: indexPath) as! TextInputCell
      cell.textInput.leftImage = #imageLiteral(resourceName: "Marker")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Location"
      cell.indexRow = indexPath.row
      return cell
    }
    
    else if indexPath.row == 3 {
      // Start Time
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell", for: indexPath) as! TextInputCell
      cell.textInput.leftImage = #imageLiteral(resourceName: "TimerEmpty")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Event Start Date Time"
      cell.indexRow = indexPath.row
      return cell
    }
      
    else if indexPath.row == 4 {
      // End Time
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell", for: indexPath) as! TextInputCell
      cell.textInput.leftImage = #imageLiteral(resourceName: "TimerFilled")
      cell.textInput.leftPadding = 40
      cell.textInput.placeholder = "Event End Date Time"
      cell.indexRow = indexPath.row
      return cell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("\n\n row selected \(indexPath.row)\n\n")
  }
  
  
}
