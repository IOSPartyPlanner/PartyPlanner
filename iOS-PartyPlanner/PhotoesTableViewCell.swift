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
    
    var photoes: [String]?
    
    var viewController: EventViewController?
    
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
        return (photoes?.count)! + 1 ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoesCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        if indexPath.row == 0 {
            cell!.photoImageView.image = UIImage(named: "add")
            let gesture = UITapGestureRecognizer(target: cell?.photoImageView, action: #selector(addPhoto(_:)))
            cell?.photoImageView.addGestureRecognizer(gesture)
        } else {
            if let photo = photoes?[indexPath.row - 1] {
                cell?.photoImageView.setImageWith(NSURL(string:photo)! as URL)
            }
            let gesture = UITapGestureRecognizer(target: cell?.photoImageView, action: #selector(selectImage(_:)))
            cell?.photoImageView.addGestureRecognizer(gesture)
        }
        Utils.formatCircleImage(image: cell!.photoImageView)
        return cell!
    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        viewController?.performSegue(withIdentifier: "showPhotos", sender: self)
    }
    
    @IBAction func addPhoto(_ sender: UITapGestureRecognizer) {
        viewController?.performSegue(withIdentifier: "addPhoto", sender: self)
    }
    
}
