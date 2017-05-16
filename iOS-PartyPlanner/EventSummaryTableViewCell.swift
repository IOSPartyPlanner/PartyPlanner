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
import QRCodeReader

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
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    var viewController: EventViewController?
    
    var event: Event? {
        didSet {
            partyNameLabel.text = event?.name
            locationLabel.text = event?.location
            
            if event?.inviteMediaType == .image {
                if event?.inviteMediaUrl != nil {
                    eventImageView = UIImageView(frame: videoView.frame)
                    eventImageView?.setImageWith(URL(string: event!.inviteMediaUrl!)!)
                    //                    eventImageView?.clipsToBounds = true
                    eventImageView?.frame.size.height = videoView.frame.height-10
                    eventImageView?.frame.size.width = videoView.frame.width-10
                    videoView.addSubview(eventImageView!)
                }
            } else {
                if event?.inviteMediaUrl != nil {
                    videoPlayView = VideoView(frame: videoView.frame)
                    videoPlayView?.setVideoURL(URL(string: event!.inviteMediaUrl!)!)
                    //                    videoPlayView?.clipsToBounds = true
                    videoPlayView?.frame.size.height = videoView.frame.height-10
                    videoPlayView?.frame.size.width = videoView.frame.width-10
                    videoView.addSubview(videoPlayView!)
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
        if (event?.isUserOnwer())! {
            readerVC.modalPresentationStyle = .formSheet
            readerVC.delegate               = self
            
            readerVC.completionBlock = { (result) in
                if let result = result {
                    self.viewController?.qcodeVerificationFailed = (result.value == self.event?.qcode)
                }
            }
            viewController?.present(readerVC, animated: true, completion: nil)
        } else {
            
            viewController?.performSegue(withIdentifier: "showQCode", sender: event)
        }
    }
    
    @IBOutlet weak var partyNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var partyDateLabel: UILabel!
    
    @IBOutlet weak var partyTimeLabel: UILabel!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var taglineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Invitation border
        videoView.layer.cornerRadius = 10
        videoView.layer.borderWidth = 1.0
        videoView.layer.borderColor = UIColor.black.cgColor
        
        videoView.layer.shadowColor = UIColor.black.cgColor
        videoView.layer.shadowOffset  = CGSize(width: 1, height: 1)
        videoView.layer.shadowOpacity = 0.7
        videoView.layer.shadowRadius = 1.0
        
        //Content view border
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 10.0
        self.contentView.layer.borderColor = UIColor.white.cgColor
        
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.3
        self.contentView.layer.shadowRadius = 10.0
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension EventSummaryTableViewCell: QRCodeReaderViewControllerDelegate {
    @IBAction func scanAction(_ sender: AnyObject) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result) in
            print(result)
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        viewController?.present(readerVC, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        viewController?.dismiss(animated: true, completion: nil)
    }
}
