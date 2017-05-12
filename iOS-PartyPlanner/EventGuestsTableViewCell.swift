//
//  EventGuestsTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EventGuestsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var guestCollectionView: UICollectionView!
    
    var guests: [User]?

    var viewController: EventViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        guestCollectionView.delegate = self
        guestCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (guests!.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = guestCollectionView.dequeueReusableCell(withReuseIdentifier: "GuestCollectionViewCell", for: indexPath) as? GuestCollectionViewCell
        if indexPath.row == 0 {
            cell!.guestImageView.image = UIImage(named: "add")
            cell!.guestImageView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(addGuest(_:)))
            cell?.guestImageView.addGestureRecognizer(gesture)
        } else {
            if let guest = guests?[indexPath.row - 1] {
                cell?.guestImageView.setImageWith(URL(string:guest.imageUrl!)! as URL)
            }
        }
        Utils.formatCircleImage(image: cell!.guestImageView)
        return cell!
    }
    
    func addGuest(_ sender: UITapGestureRecognizer) {
        viewController?.performSegue(withIdentifier: "addGuest", sender: self)
    }
}
