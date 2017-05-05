//
//  PhotoesTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/29/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var photoesCollectionView: UICollectionView!
    
    var photoes: [URL]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoesCollectionView.delegate = self
        photoesCollectionView.dataSource = self
        
//        let flowLayout = photoesCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout.estimatedItemSize = CGSize(width: 92.0, height: 92.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoesCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        
        if let photo = photoes?[indexPath.row] {
            cell?.photoImageView.setImageWith(photo)
        }
        return cell!
    }

}
