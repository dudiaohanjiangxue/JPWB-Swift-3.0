//
//  JPHomeViewController.swift
//  JPWB-Swift 3.0
//
//  Created by KC on 16/10/10.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPHomeViewController: JPBaseViewController {

    //MARK: - 懒加载
    lazy var titleBtn: JPTitleButton = {
        let btn: JPTitleButton = JPTitleButton()
        btn.setTitle("陈锦彭", for: UIControlState())
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setImage(UIImage(named: "navigationbar_arrow_up"), for: .normal)
        btn.setImage(UIImage(named: "navigationbar_arrow_down"), for: .selected)
        btn.sizeToFit()
        return btn
    }()
    
    lazy var animationor : JPAnimationor = JPAnimationor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.没有登录的页面
        if !isLogin{
            vistorView.addRotationAnmation()
            return
        }
        
        //2.登录的页面
        setupNavigationItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

extension JPHomeViewController {
    fileprivate func setupNavigationItem() {
     
        // 1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(leftItemClick))
        
        // 2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightItemClick))
        
        //3.中间的标题
         navigationItem.titleView = titleBtn
        titleBtn.addTarget(self, action: #selector(titleBtnClick(titleBtn:)), for: .touchUpInside)
    }

}

extension JPHomeViewController {
    @objc fileprivate func leftItemClick() {
        print("leftItemClick")
    }
    
    @objc fileprivate func rightItemClick() {
        print("rightItemClick")
        
    }
    
    @objc fileprivate func titleBtnClick(titleBtn : JPTitleButton) {
//        titleBtn.isSelected = !titleBtn.isSelected
        //弹出
        let modalVC = JPModalViewController()
        modalVC.modalPresentationStyle = .custom
    
        animationor.presentViewFrame = CGRect(x: 110, y: 55, width: 180, height: 250)
        
        animationor.animationCallBack = {[weak self] (ispresent: Bool) -> Void in
        
        self?.titleBtn.isSelected = ispresent
        }
        modalVC.transitioningDelegate = animationor
        
        self.present(modalVC, animated: true, completion: nil)
    }
}

