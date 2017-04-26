//
//  EventSummaryTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerButton: UIButton {
    let pauseImage = UIImage(named: "pause")
    
    let playImage = UIImage(named: "play")
    
    var pauseStaus: Bool {
        didSet {
            if pauseStaus == true {
                setImage(pauseImage, for: .normal)
            } else {
                setImage(playImage, for: .normal)
            }
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VideoView: UIView {
    var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVideoURL(_ videoURL: URL) {
        player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        layer.addSublayer(playerLayer)
        playerLayer.frame = frame
        player!.play()
    }
}

class EventSummaryTableViewCell: UITableViewCell {
    var event: Event?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
