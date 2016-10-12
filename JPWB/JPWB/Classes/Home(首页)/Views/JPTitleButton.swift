//
//  JPTitleButton.swift
//  JPWB
//
//  Created by KC on 16/10/11.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPTitleButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        let totalWidth = (titleLabel?.frame.width)! + (imageView?.frame.width)!
        let titleLabelX = (frame.width - totalWidth) * 0.5
        
        var titleLabelFrame = titleLabel?.frame
        var imageFrame = imageView?.frame
        
        titleLabelFrame?.origin.x = titleLabelX
        titleLabel?.frame = titleLabelFrame!
        
        imageFrame?.origin.x = (titleLabel?.frame.maxX)!
        imageView?.frame = imageFrame!
        
    }

}
