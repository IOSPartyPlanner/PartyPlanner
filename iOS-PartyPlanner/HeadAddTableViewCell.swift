//
//  HeadAddTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 5/12/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class HeadAddTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addImageView: UIImageView!
    
    var viewController: EventViewController?
    
    var segueName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(performSegue(_:)))
        addImageView.addGestureRecognizer(gesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func performSegue(_ sender: UITapGestureRecognizer) {
        viewController?.performSegue(withIdentifier: segueName!, sender: viewController)
    }

}
