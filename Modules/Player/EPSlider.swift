//
//  EPSlider.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/3/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

class EPSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        if let image = UIImage(named: "progressthumb") {
            setThumbImage(image, forState: UIControlState.Normal)
        }
        
        if let image = UIImage(named: "minimage") {
            setMinimumTrackImage(image, forState: UIControlState.Normal)
        }
        
        if let image = UIImage(named: "maximage") {
            setMaximumTrackImage(image, forState: UIControlState.Normal)
        }
    }

}
