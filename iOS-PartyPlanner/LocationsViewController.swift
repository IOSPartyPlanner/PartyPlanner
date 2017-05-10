//
//  LocationsViewController.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 5/9/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//
//  Created by Timothy Lee on 10/20/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol LocationsViewControllerDelegate {
  @objc optional func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber)
  @objc optional func locationsPickedLocation(controller: LocationsViewController, location: String)
  @objc optional func locationsPickedLocation(controller: LocationsViewController, cancelled: String)
}

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  // TODO: Fill in actual CLIENT_ID and CLIENT_SECRET
  let CLIENT_ID = "QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL"
  let CLIENT_SECRET = "W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU"
  weak var delegate: LocationsViewControllerDelegate!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var results: NSArray = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onCancel(_ sender: Any) {
    delegate?.locationsPickedLocation!(controller: self, cancelled: "cancel")
    navigationController?.popViewController(animated: true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
    
    cell.location = results[(indexPath as NSIndexPath).row] as! NSDictionary
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // This is the selected venue
    let venue = results[(indexPath as NSIndexPath).row] as! NSDictionary
    
    var address = venue.value(forKeyPath: "location.address") as? String
    let addressName = venue["name"] as? String
    print("Selected address Name \(addressName!)")
    print("Selected address \(address!)")
    if address == nil {
      address = addressName
    }
    delegate?.locationsPickedLocation!(controller: self, location: address!)
    navigationController?.popViewController(animated: true)
  }
  
  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let newText = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
    fetchLocations(newText)
    
    return true
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    fetchLocations(searchBar.text!)
  }
  
  func fetchLocations(_ query: String, near: String = "San Francisco") {
    let baseUrlString = "https://api.foursquare.com/v2/venues/search?"
    let queryString = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20141020&near=\(near),CA&query=\(query)"
    
    let url = URL(string: baseUrlString + queryString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
    let request = URLRequest(url: url)
    
    let session = URLSession(
      configuration: URLSessionConfiguration.default,
      delegate:nil,
      delegateQueue:OperationQueue.main
    )
    
    let task : URLSessionDataTask = session.dataTask(with: request,
                                                     completionHandler: { (dataOrNil, response, error) in
                                                      if let data = dataOrNil {
                                                        if let responseDictionary = try! JSONSerialization.jsonObject(
                                                          with: data, options:[]) as? NSDictionary {
                                                          NSLog("response: \(responseDictionary)")
                                                          self.results = responseDictionary.value(forKeyPath: "response.venues") as! NSArray
                                                          self.tableView.reloadData()
                                                          
                                                        }
                                                      }
    });
    task.resume()
  }
  
}
