//
//  AddInfoViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 5/12/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class AddTextInputCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var placeHolderText: String? {
        didSet {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textView.delegate = self

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
        }
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

class DatePickerCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


class AddInfoViewController: UIViewController {
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var addInfoTableView: UITableView!
    
    var textView: UITextView?
    
    weak var dateValueLabel: UILabel!
    
    var type: String?
    
    var isDateMode: Bool = false
    
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addInfoTableView.delegate = self
        addInfoTableView.dataSource = self
        
        addInfoTableView.rowHeight = UITableViewAutomaticDimension
        addInfoTableView.estimatedRowHeight = 100
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        switch type! {
            case "Comment":
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
        case "Task":
            if isDateMode {
                return 3
            } else {
                return 2
            }
        case "QCode", "Comment":
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            isDateMode = !isDateMode
            if !isDateMode {
                if let date = datePicker?.date {
                    dateValueLabel.text = dateFormatter.string(from: date)
                }
            } else {
                datePicker?.setDate(dateFormatter.date(from: dateValueLabel.text!)!, animated: true)
            }
            addInfoTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = addInfoTableView.dequeueReusableCell(withIdentifier: "AddTextInputCell", for: indexPath) as? AddTextInputCell
            textView = cell?.textView
            switch type! {
            case "Task":
                cell?.placeHolderText = "Please add your task here"
            case "QCode":
                cell?.placeHolderText = "Add your message to generate QCode"
            case "Comment":
                cell?.placeHolderText = "Add you comment for this event"
            default:
                break
            }
            return cell!
        case 1:
            let cell = addInfoTableView.dequeueReusableCell(withIdentifier: "DateSelectionCell", for: indexPath) as? DateSelectionCell
            switch type! {
            case "Task":
                cell?.dateLabel.text = "Due"
                if cell?.dateValueLabel.text == "Label" {
                    cell?.dateValueLabel.text = dateFormatter.string(from: Date())
                }
            default:
                break
            }
            dateValueLabel = cell?.dateValueLabel
            return cell!
        default:
            let cell = addInfoTableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as? DatePickerCell
            datePicker = cell?.datePicker
            return cell!
            
        }
    }
}
