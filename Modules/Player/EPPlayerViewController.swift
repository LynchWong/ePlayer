//
//  EPPlayerViewController.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/2/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MediaPlayer

enum EPPanType {
    case None
    case Brightness
    case Seek
    case Volume
}

class EPPlayerViewController: EPViewController {
    
    var media: VLCMedia!
    
    @IBOutlet weak var playerView: EPPlayerView!
    
    @IBOutlet weak var topPanel: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    
    @IBOutlet weak var botPanel: UIView!
    @IBOutlet weak var staTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backedButton: UIButton!
    @IBOutlet weak var forwadButton: UIButton!
    @IBOutlet weak var progSlider: EPSlider!
    @IBOutlet weak var lockButton: UIButton!
    
    @IBOutlet weak var volumeView: MPVolumeView!
    private var volumeSlider: UISlider!
    
    @IBOutlet weak var centralPlayButton: UIButton!
    
    @IBOutlet weak var topPanelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var botPanelBotConstraint: NSLayoutConstraint!
    
    
    
    private var needAutorotate = true
    private var needStatusBarHidden = false
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVolumeSlider()
        initControls()
        initPlayerView()
        initGestureRecognizer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        playerView.mediaPlayer.removeObserver(self, forKeyPath: "time")
        playerView.mediaPlayer.removeObserver(self, forKeyPath: "remainingTime")
        if playerView.mediaPlayer.media != nil {
            playerView.mediaPlayer.stop()
        }
    }
    
    func initVolumeSlider() {
        for aView in volumeView.subviews {
            if aView.isKindOfClass(UISlider.classForCoder()) {
                volumeSlider = aView as! UISlider
//                volumeSlider.addTarget(self, action: #selector(EPPlayerViewController.volumeSliderAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
                if let image = UIImage(named: "thumb") {
                    volumeSlider.setThumbImage(image, forState: UIControlState.Normal)
                }
                break
            }
        }
    }
    
    func initControls() {
        backButton.rx_tap
            .subscribeNext { [unowned self] () in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        
        mediaTitleLabel?.text = media.metaDictionary[VLCMetaInformationTitle] as? String
        
        backedButton.rx_tap
            .subscribeNext { [unowned self] () in
                self.playerView.mediaPlayer.jumpBackward(10)
            }
            .addDisposableTo(disposeBag)
        
        forwadButton.rx_tap
            .subscribeNext { [unowned self] () in
                self.playerView.mediaPlayer.jumpForward(30)
            }
            .addDisposableTo(disposeBag)
        
        playButton.rx_tap
            .subscribeNext { [unowned self] () in
                if self.playerView.mediaPlayer.playing {
                    self.playerView.mediaPlayer.pause()
                    self.centralPlayButton.hidden = false
                    self.playButton.setImage(UIImage(named: "play")!, forState: UIControlState.Normal)
                } else {
                    self.playerView.mediaPlayer.play()
                    self.centralPlayButton.hidden = true
                    self.playButton.setImage(UIImage(named: "pause")!, forState: UIControlState.Normal)
                }
            }
            .addDisposableTo(disposeBag)
        
        centralPlayButton.rx_tap
            .subscribeNext { () in
                if !self.playerView.mediaPlayer.playing {
                    self.playerView.mediaPlayer.play()
                    self.centralPlayButton.hidden = true
                    self.playButton.setImage(UIImage(named: "pause")!, forState: UIControlState.Normal)
                }
            }
            .addDisposableTo(disposeBag)
        
        progSlider.rx_value
            .subscribeNext { [unowned self] position in
                self.playerView.mediaPlayer.position = position
            }
            .addDisposableTo(disposeBag)
        
        lockButton.rx_tap
            .subscribeNext { [unowned self] () in
                if self.needAutorotate {
                    self.needAutorotate = false
                } else {
                    self.needAutorotate = true
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func initPlayerView() {
        playerView.userInteractionEnabled = false
        playerView.mediaPlayer.media = media
        playerView.mediaPlayer.addObserver(self, forKeyPath: "time", options: NSKeyValueObservingOptions.New, context: nil)
        playerView.mediaPlayer.addObserver(self, forKeyPath: "remainingTime", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    func initGestureRecognizer() {
        let tapOnVideoRecognizer = UITapGestureRecognizer(target: self, action: #selector(EPPlayerViewController.togglePanelVisible(_:)))
        tapOnVideoRecognizer.delegate = self
        view.addGestureRecognizer(tapOnVideoRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(EPPlayerViewController.panRecognized(_:)))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        
        let swipeRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(EPPlayerViewController.swipeRecognized(_:)))
        swipeRecognizerLeft.direction = UISwipeGestureRecognizerDirection.Left
        let swipeRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(EPPlayerViewController.swipeRecognized(_:)))
        swipeRecognizerRight.direction = UISwipeGestureRecognizerDirection.Right
        let swipeRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(EPPlayerViewController.swipeRecognized(_:)))
        swipeRecognizerUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeRecognizerUp.numberOfTouchesRequired = 2
        let swipeRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(EPPlayerViewController.swipeRecognized(_:)))
        swipeRecognizerDown.direction = UISwipeGestureRecognizerDirection.Down
        swipeRecognizerDown.numberOfTouchesRequired = 2
        
        view.addGestureRecognizer(swipeRecognizerLeft)
        view.addGestureRecognizer(swipeRecognizerRight)
        view.addGestureRecognizer(swipeRecognizerUp)
        view.addGestureRecognizer(swipeRecognizerDown)
        view.addGestureRecognizer(panRecognizer)
        
        panRecognizer.requireGestureRecognizerToFail(swipeRecognizerLeft)
        panRecognizer.requireGestureRecognizerToFail(swipeRecognizerRight)
        panRecognizer.requireGestureRecognizerToFail(swipeRecognizerUp)
        panRecognizer.requireGestureRecognizerToFail(swipeRecognizerDown)
        
        panRecognizer.delegate = self
        swipeRecognizerLeft.delegate = self
        swipeRecognizerRight.delegate = self
        swipeRecognizerUp.delegate = self
        swipeRecognizerDown.delegate = self
    }
    
    // MARK: - Action
    
//    func volumeSliderAction(slider: UISlider) {
//        volume = slider.value
//    }
    
    // MARK: - Observer
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        progSlider.value = playerView.mediaPlayer.position
        staTimeLabel.text = playerView.mediaPlayer.time.stringValue
        endTimeLabel.text = playerView.mediaPlayer.remainingTime.stringValue
    }
    
    // MARK: - UITapGestureRecognizer
    
    func togglePanelVisible(tapGestureRecognizer: UITapGestureRecognizer) {
        print("tap")
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.3) { 
            if self.topPanelTopConstraint.constant == -64.0 && self.botPanelBotConstraint.constant == -74.0 {
                self.topPanelTopConstraint.constant = 0.0
                self.topPanel.alpha = 1.0
                self.botPanelBotConstraint.constant = 0.0
                self.botPanel.alpha = 1.0
                self.needStatusBarHidden = false
            } else {
                self.topPanelTopConstraint.constant = -64.0
                self.topPanel.alpha = 0.0
                self.botPanelBotConstraint.constant = -74.0
                self.botPanel.alpha = 0.0
                self.needStatusBarHidden = true
            }
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        }
    }
    
    func panRecognized(panRecognizer: UIPanGestureRecognizer) {
//        let panDirectionX = panRecognizer.velocityInView(view).x
        let panDirectionY = panRecognizer.velocityInView(view).y
        
        var panType = EPPanType.None
        if panRecognizer.state == UIGestureRecognizerState.Began {
            panType = detectPanTypeForPan(panRecognizer)
        }
        
        guard panType != EPPanType.None else {
            return
        }
        
        if case panType = EPPanType.Seek {
            
        } else if case panType = EPPanType.Volume {
            if panDirectionY > 0 {
                volumeSlider.value -= 0.05
            } else {
                volumeSlider.value += 0.05
            }
        } else if case panType = EPPanType.Brightness {
            var brightness = UIScreen.mainScreen().brightness
            
            if panDirectionY > 0 {
                brightness = brightness - 0.05
            } else {
                brightness = brightness + 0.05
            }
            
            if brightness > 1.0 {
                brightness = 1.0
            } else if brightness < 0.0 {
                brightness = 0.0
            }
            
            UIScreen.mainScreen().brightness = brightness
        }
        
    }
    
    func swipeRecognized(swipeRecognizer: UISwipeGestureRecognizer) {
        let forwDuration: Int32 = 20
        let backDuration: Int32 = 10
        if swipeRecognizer.direction == UISwipeGestureRecognizerDirection.Right || swipeRecognizer.direction == UISwipeGestureRecognizerDirection.Up {
            let timeRemaining = Int32(Double(-playerView.mediaPlayer.remainingTime.intValue) * 0.001)
            if forwDuration < timeRemaining {
                playerView.mediaPlayer.jumpForward(forwDuration)
            } else {
                playerView.mediaPlayer.jumpForward(timeRemaining - 5)
            }
        } else if swipeRecognizer.direction == UISwipeGestureRecognizerDirection.Left || swipeRecognizer.direction == UISwipeGestureRecognizerDirection.Down {
            playerView.mediaPlayer.jumpBackward(backDuration)
        }
    }
    
    func detectPanTypeForPan(panRecognizer: UIPanGestureRecognizer) -> EPPanType {
        guard let window = UIApplication.sharedApplication().keyWindow else {
            return EPPanType.None
        }
        
        let windowWidth = CGRectGetWidth(window.bounds)
        let location = panRecognizer.locationInView(window)
        
        var panType = EPPanType.Volume
        if location.x < windowWidth / 2 {
            panType = EPPanType.Brightness
        }
        
        return panType
    }
    
    // MARK: - Device Orientation
    
    override func shouldAutorotate() -> Bool {
        return needAutorotate
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    // MARK: - Status Bar
    
    override func prefersStatusBarHidden() -> Bool {
        return needStatusBarHidden
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}

extension EPPlayerViewController: VLCMediaPlayerDelegate { }

extension EPPlayerViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view != self.view {
            return false
        }
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
