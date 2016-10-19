//
//  JPHomeStatusCell.swift
//  JPWB
//
//  Created by KC on 16/10/19.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import Kingfisher
private let edgeMargin: CGFloat = 15

class JPHomeStatusCell: UITableViewCell {
      //MARK: - 属性
    
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelWidthConst: NSLayoutConstraint!
    
    var statusViewModal: JPStatusViewModel? {
        didSet{
            guard let statusViewModal = statusViewModal else {
                return
            }
            
            iconView.kf.setImage(with:statusViewModal.iconUrl)
            verifiedImageView.image = statusViewModal.verifiedImage
            vipView.image = statusViewModal.vipImage
            nameLabel.text = statusViewModal.status?.user?.screen_name
            timeLabel.text = statusViewModal.createdAtString
            sourceLabel.text = statusViewModal.sourceText
            contentLabel.text = statusViewModal.status?.text
            
            
        
        }
    
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabelWidthConst.constant = UIScreen.main.bounds.width - 2 * edgeMargin
    }
    
//    override var frame: CGRect{
//        didSet{
//            frame.size.height = frame.size.height - 10
//            
//        }
//    
//    }

    
}
