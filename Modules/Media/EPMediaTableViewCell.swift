//
//  EPMediaTableViewCell.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/3/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

class EPMediaTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(media: VLCMedia) {
        titleLabel?.text = media.metaDictionary[VLCMetaInformationTitle] as? String
        selectionStyle = UITableViewCellSelectionStyle.None
        let thumbnailer = VLCMediaThumbnailer(media: media, andDelegate: self)
        thumbnailer.snapshotPosition = 0.1
        thumbnailer.fetchThumbnail()
    }

}

extension EPMediaTableViewCell: VLCMediaThumbnailerDelegate {

    func mediaThumbnailerDidTimeOut(mediaThumbnailer: VLCMediaThumbnailer!) {
        
    }
    
    func mediaThumbnailer(mediaThumbnailer: VLCMediaThumbnailer!, didFinishThumbnail thumbnail: CGImage!) {
        thumbnailImage?.image = UIImage(CGImage: thumbnail)
    }
    
}
