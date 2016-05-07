//
//  EPVolumeView.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/4/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit
import MediaPlayer

class EPVolumeView: MPVolumeView {

    override func volumeSliderRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.volumeSliderRectForBounds(bounds)
        // fix height and y origin
        rect.size.height = bounds.size.height;
        rect.origin.y = bounds.origin.y;
        return rect
    }
    
    override func routeButtonRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.routeButtonRectForBounds(bounds)
        // fix height and y origin
        rect.size.height = bounds.size.height;
        rect.origin.y = bounds.origin.y;
        return rect;
    }

}
