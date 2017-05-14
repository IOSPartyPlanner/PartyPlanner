//
//  EventSummaryTableViewCell.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoView: UIView {
    let pauseImage = UIImage(named: "pause")
    
    let playImage = UIImage(named: "play")
    
    var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                avPlayButton.setImage(pauseImage, for: .normal)
                playerController.player?.play()
            } else {
                avPlayButton.setImage(playImage, for: .normal)
                playerController.player?.pause()
            }
        }
    }
    
    let avPlayButton: UIButton =  {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "play.png"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var playerController = AVPlayerViewController()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
    }()
    
    let controlsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func switchPlay() {
        isPlaying = !isPlaying
    }
    
    func setVideoURL(_ videoURL: URL) {
        let player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = false
        
        playerController.view.frame = frame
        addSubview(playerController.view)
        playerController.view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playerController.view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        //playerController.player!.play()
        playerController.player!.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        print(playerController.view.frame)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            addSubview(avPlayButton)
            avPlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            avPlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            avPlayButton.addTarget(self, action: #selector(switchPlay), for: UIControlEvents.touchUpInside)
        }
    }

}

class EventSummaryTableViewCell: UITableViewCell {
    var videoPlayView: VideoView?
    
    var eventImageView: UIImageView?
    
    @IBOutlet weak var barcodeImageView: UIImageView!
    
    var viewController: EventViewController?
    
    var event: Event? {
        didSet {
            partyNameLabel.text = event?.name
            locationLabel.text = event?.location
            
            if event?.inviteMediaType == .image {
                if event?.inviteMediaUrl != nil {
                    eventImageView?.setImageWith(URL(string: event!.inviteMediaUrl!)!)
                }
            } else {
                if event?.inviteMediaUrl != nil {
                    videoPlayView?.setVideoURL(URL(string: event!.inviteMediaUrl!)!)
                }
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            partyDateLabel.text = dateFormatter.string(from: (event?.dateTime)!)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short
            partyTimeLabel.text = timeFormatter.string(from: (event?.dateTime)!)
            
            taglineLabel.text = event?.tagline
            
            if !(event?.isPast())! {
                if let qcode = event?.qcode {
                    if qcode.characters.count > 0 {
                        let data = qcode.data(using: .isoLatin1, allowLossyConversion: false)
                        let filter = CIFilter(name: "CIQRCodeGenerator")
                        filter?.setValue(data, forKey: "inputMessage")
                        filter?.setValue("Q", forKey: "inputCorrectionLevel")
                        
                        barcodeImageView.image = convert((filter?.outputImage)!)
                        barcodeImageView.isUserInteractionEnabled = true
                        
                        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleQCode(_:)))
                        barcodeImageView.addGestureRecognizer(gesture)
                    }
                }
            }
        }
    }
    
    func convert(_ cmage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
    func handleQCode(_ sender: UITapGestureRecognizer) {
        viewController?.performSegue(withIdentifier: "handleQCode", sender: event)
    }
    
    @IBOutlet weak var partyNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var partyDateLabel: UILabel!
    
    @IBOutlet weak var partyTimeLabel: UILabel!

    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var taglineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        if event?.inviteMediaType == .image {
            eventImageView = UIImageView(frame: videoView.frame)
            videoView.addSubview(eventImageView!)
        } else {
            videoPlayView = VideoView(frame: videoView.frame)
            videoView.addSubview(videoPlayView!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
