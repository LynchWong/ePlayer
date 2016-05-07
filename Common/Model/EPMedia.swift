//
//  EPMedia.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/3/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import Foundation

class EPMedia {

    var path: String
    
    var media: VLCMedia {
        return VLCMedia(path: path)
    }
    
    init(path: String) {
        self.path = path
    }
    
}