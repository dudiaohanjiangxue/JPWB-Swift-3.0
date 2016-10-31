//
//  JPPhotoBrowserAnimator.swift
//  JPWB
//
//  Created by KC on 16/10/31.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit


protocol JPPhotoBrowserPresentedDelegate {
    func startRectForPresentedView(indexPath : IndexPath) -> CGRect?
    func endRectForPresentedView(indexPath : IndexPath) -> CGRect?
    func imageViewForPresentedView(indexPath : IndexPath) -> UIImageView?
}

protocol JPPhotoBrowserDismissDelegate {
    func imageViewForDismissView() -> UIImageView?
    func indexPathForDimissView() -> IndexPath?
}

class JPPhotoBrowserAnimator: NSObject {
    var isPresented: Bool = false
    
    var presentedDelegate: JPPhotoBrowserPresentedDelegate?
    var dismissDelegate: JPPhotoBrowserDismissDelegate?
    var indexPath : IndexPath?
    
}

extension JPPhotoBrowserAnimator: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}


extension JPPhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animateForPresentedView(transitionContext: transitionContext) : animateForDismissView(transitionContext: transitionContext)
        
    }

}


extension JPPhotoBrowserAnimator {
    //弹出动画
    func animateForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        //nil值校验
        guard let presentedDelegate = presentedDelegate, let indexPath = indexPath else {
            return
        }
        //1.取出弹出的view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(presentedView)
        presentedView.alpha = 0.0
        
        //2.执行动画
        guard let  imageView = presentedDelegate.imageViewForPresentedView(indexPath: indexPath), let startFrame = presentedDelegate.startRectForPresentedView(indexPath: indexPath), let endFrame = presentedDelegate.endRectForPresentedView(indexPath: indexPath) else {
            return
        }
        transitionContext.containerView.addSubview(imageView)
        transitionContext.containerView.backgroundColor = UIColor.black
        imageView.frame = startFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
           imageView.frame = endFrame
            }) { (_) in
                presentedView.alpha = 1.0
                imageView.removeFromSuperview()
                transitionContext.containerView.backgroundColor = UIColor.clear
                transitionContext.completeTransition(true)
        }
    }
    
    //消失动画
    func animateForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        //1.空值校验
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        //2.移除图片浏览器
        let dismissView = transitionContext.view(forKey: .from)!
         dismissView.removeFromSuperview()
        
        //3.执行模拟动画
        
        guard let indexPath = dismissDelegate.indexPathForDimissView() else {
            return
        }
        guard let imageView = dismissDelegate.imageViewForDismissView(), let endFrame = presentedDelegate.startRectForPresentedView(indexPath: indexPath) else {
            return
        }
        transitionContext.containerView.addSubview(imageView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            imageView.frame = endFrame
            }) { (_) in
               imageView.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }

}
