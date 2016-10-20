//
//  JPHomeStatusCell.swift
//  JPWB
//
//  Created by KC on 16/10/19.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import Kingfisher

class JPHomeStatusCell: UITableViewCell {
      //MARK: - 属性
    
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var reweeted_statusContent: UILabel!
    @IBOutlet weak var pic_collectionView: JPPicCollectionView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var contentLabelWidthConst: NSLayoutConstraint!
    @IBOutlet weak var reweeted_statusComtentLabelConst: NSLayoutConstraint!

    @IBOutlet weak var reweeted_statusCntentLabelTopConst: NSLayoutConstraint!
    @IBOutlet weak var pic_collectionViewTopConst: NSLayoutConstraint!
    
    
    var statusViewModal: JPStatusViewModel? {
        didSet{
            guard let statusViewModal = statusViewModal else {
                return
            }
            //数据赋值
            iconView.kf.setImage(with:statusViewModal.iconUrl)
            verifiedImageView.image = statusViewModal.verifiedImage
            vipView.image = statusViewModal.vipImage
            nameLabel.text = statusViewModal.status?.user?.screen_name
            timeLabel.text = statusViewModal.createdAtString
            sourceLabel.text = statusViewModal.sourceText
            contentLabel.text = statusViewModal.status?.text
            
            if let reweeted_status = statusViewModal.status?.retweeted_status {
                
                reweeted_statusContent.text = "@" + (reweeted_status.user?.screen_name)! + ":" + (reweeted_status.text ?? "")
                reweeted_statusCntentLabelTopConst.constant = 15
                reweeted_statusContent.isHidden = false
            }else {
                reweeted_statusContent.text = nil
                reweeted_statusCntentLabelTopConst.constant = 0
                reweeted_statusContent.isHidden = true
            }
            
            pic_collectionViewTopConst.constant = statusViewModal.picURLs.count != 0 ? 10 : 0
            //collectView的数据源
            pic_collectionView.picUrls = statusViewModal.picURLs

            JPPrint(statusViewModal.picURLs)
            
        }
    
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabelWidthConst.constant = UIScreen.main.bounds.width - 2 * JPHomeConst.edgeMargin
        reweeted_statusComtentLabelConst.constant = UIScreen.main.bounds.width - 2 * JPHomeConst.edgeMargin
    }
    
//    override var frame: CGRect{
//        didSet{
//            frame.size.height = frame.size.height - 10
//            
//        }
//    
//    }

    
}

extension JPHomeStatusCell {
    
    func cellHeight(statusViewModal: JPStatusViewModel) -> CGFloat {
        self.statusViewModal = statusViewModal
        self.layoutIfNeeded()
        return bottomView.frame.maxY
    }
  
}
