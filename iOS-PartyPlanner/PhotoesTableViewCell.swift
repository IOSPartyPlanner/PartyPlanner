//
//  PhotoesTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/29/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import AFNetworking
import MWPhotoBrowser

class PhotoesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var photoesCollectionView: UICollectionView!
    
    var photoes: [String]? {
        didSet {
            photos = photoes?.map({return URL(string: $0)}).map({ return MWPhoto.init(url: $0)})
        }
    }
    
    var viewController: EventViewController?
    
    var photos: [MWPhoto]?
    
    var browser: MWPhotoBrowser?
    
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
            cell?.photoImageView.setImageWith(URL(string:photo)!)
            cell?.photoImageView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(selectImage(_:)))
            cell?.addGestureRecognizer(gesture)
        }
//        Utils.formatCircleImage(image: cell!.photoImageView)
        cell!.photoImageView.layer.cornerRadius = 6
        return cell!
    }
    
    func selectImage(_ sender: UITapGestureRecognizer) {
        let cell = sender.view as? UICollectionViewCell
        let indexPath = photoesCollectionView.indexPath(for: cell!)
        
        browser = MWPhotoBrowser(delegate: self)
        browser?.displayActionButton = true
        browser?.displayNavArrows = true
        browser?.displaySelectionButtons = true
        
        browser?.setCurrentPhotoIndex(UInt((indexPath?.row)!))
        viewController?.navigationController?.pushViewController(browser!, animated: true)
    }
    
    func addPhoto(_ sender: UITapGestureRecognizer) {
        viewController?.performSegue(withIdentifier: "addPhoto", sender: self)
    }
    
}

extension PhotoesTableViewCell: MWPhotoBrowserDelegate {
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt((photos?.count)!)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        let uindex = Int(index)
        if uindex < (photos?.count)! {
            return photos![uindex]
        }
        
        return nil
    }
}
