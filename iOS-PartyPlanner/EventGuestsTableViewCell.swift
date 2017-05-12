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
        return guests!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = guestCollectionView.dequeueReusableCell(withReuseIdentifier: "GuestCollectionViewCell", for: indexPath) as? GuestCollectionViewCell

        if let guest = guests?[indexPath.row] {
            cell?.guestImageView.setImageWith(URL(string:guest.imageUrl!)! as URL)
        }
        Utils.formatCircleImage(image: cell!.guestImageView)
        return cell!
    }
}
