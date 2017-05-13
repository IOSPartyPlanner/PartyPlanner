//
//  AddInfoViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 5/12/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class AddTextInputCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class DateSelectionCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dateValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class AddInfoViewController: UIViewController {

    @IBOutlet weak var addInfoTableView: UITableView!
    
    weak var textView: UITextView!
    
    var type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch type! {
            case "Comments":
                navigationItem.title = "Add your comments here"
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addComment(_:)))
            case "QCode":
                navigationItem.title = "Input the qcode message for this event"
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Generate", style: .plain, target: self, action: #selector(generateQCode(_:)))
            case "Task":
                navigationItem.title = "Add your task here"
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTask(_:)))
            default:
                break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addComment(_ item: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    func generateQCode(_ item: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func addTask(_ item: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
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

extension AddInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type! {
        case "Comments":
            return 2
        case "QCode":
            return 1
        case "Task":
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = addInfoTableView.dequeueReusableCell(withIdentifier: "AddTextInputCell", for: indexPath) as? AddTextInputCell
            return cell!
        } else {
            let cell = addInfoTableView.dequeueReusableCell(withIdentifier: "DateSelectionCell", for: indexPath) as? DateSelectionCell
            return cell!
        }
    }
}
