//
//  JPPresentationController.swift
//  JPWB
//
//  Created by KC on 16/10/11.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPPresentationController: UIPresentationController {
  
    //MARK: - 懒加载
    lazy var coverView: UIView = UIView()
    var presentViewFrame = CGRect.zero
    
    
    
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //1.设置弹出来的View的frame
        presentedView?.frame = presentViewFrame
        print(presentedViewController.view, presentedView)
        //2.添加蒙版
        setupCoverView()
    }
}


extension JPPresentationController {
    
    fileprivate func setupCoverView() {
        
       coverView.frame = containerView!.bounds
       coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.1)
        //监听蒙版点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModalView))
        coverView.addGestureRecognizer(tap)
        
        containerView?.insertSubview(coverView, belowSubview: presentedView!)
    
    }
   
}

extension JPPresentationController {
  
    @objc fileprivate func dismissModalView() {
    
       presentedViewController.dismiss(animated: true, completion: nil)
    }


}


