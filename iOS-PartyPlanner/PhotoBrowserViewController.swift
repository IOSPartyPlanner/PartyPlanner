//
//  PhotoBrowserViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 5/7/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import MWPhotoBrowser

class PhotoBrowserViewController: UIViewController, MWPhotoBrowserDelegate {
    var photosURL: [URL] = [] {
        didSet {
            photos = photosURL.map{ return MWPhoto.init(url: $0)}
        }
    }
    
    var startIndex: Int = 1
    
    var photos: [MWPhoto]?
    
    var browser: MWPhotoBrowser?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        browser = MWPhotoBrowser(delegate: self)
        browser?.displayActionButton = true
        browser?.displayNavArrows = true
        browser?.displaySelectionButtons = true
        
        browser?.setCurrentPhotoIndex(UInt(startIndex))
        self.navigationController?.pushViewController(browser!, animated: true)
//        browser?.showNextPhoto(animated: true)
//        browser?.showPreviousPhoto(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
