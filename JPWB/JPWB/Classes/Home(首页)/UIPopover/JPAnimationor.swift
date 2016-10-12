//
//  JPAnimationor.swift
//  JPWB
//
//  Created by KC on 16/10/11.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPAnimationor: NSObject {
    
    var isPresent = false //动画是否谈书的标志位
    var presentViewFrame = CGRect.zero
    
    var animationCallBack : ((_ isPresent: Bool) -> ())?
}


extension JPAnimationor: UIViewControllerTransitioningDelegate {
    // 目的:改变弹出View的尺寸和添加蒙版
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentVC = JPPresentationController(presentedViewController: presented, presenting: presenting)
           presentVC.presentViewFrame = presentViewFrame
        return presentVC
    }
    
    //弹出动画交给谁管理
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        if animationCallBack != nil {
            animationCallBack!(isPresent)
        }
        return self
    }
    
    //消失动画交给谁管理
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        if animationCallBack != nil {
            animationCallBack!(isPresent)
        }
        return self
    }
    
}

extension JPAnimationor : UIViewControllerAnimatedTransitioning {
    
    //弹出动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    //动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresent ? presenedAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
        
    }
    
    //弹出动画
    fileprivate func presenedAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(presentView)
        presentView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.0)
        presentView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.000001)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentView.transform = CGAffineTransform.identity
            }, completion: { (_) in
                transitionContext.completeTransition(true)
        })
    }
    
    //消失动画
    fileprivate func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
    
        let dismissView = transitionContext.view(forKey: .from)!
//        dismissView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0001)
            }, completion: { (_) in
                dismissView.removeFromSuperview()
                transitionContext.completeTransition(true)
        })
    }
    
    
}
