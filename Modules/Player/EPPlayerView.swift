//
//  EPPlayerView.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/3/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import Foundation

class EPPlayerView: UIView {

    let mediaPlayer = VLCMediaPlayer()

    var media: VLCMedia = VLCMedia()  {
        willSet {
            /* create a media object and give it to the player */
            mediaPlayer.media = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        /* setup the media player instance, give it a delegate and something to draw into */
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self
    }
    
    deinit { }

}

extension EPPlayerView: VLCMediaPlayerDelegate { }