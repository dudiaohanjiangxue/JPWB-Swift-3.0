//
//  JPBaseViewController.swift
//  JPWB
//
//  Created by KC on 16/10/11.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPBaseViewController: UITableViewController {
    
    
    lazy var vistorView : JPVisitorView = JPVisitorView.visitorView()
    var isLogin : Bool = false
    
    override func loadView() {
       isLogin ? super.loadView() : setupVisitorView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

   
}

extension JPBaseViewController {
 
    fileprivate func setupVisitorView() {
    
      view = vistorView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerBarItemDidClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self
            , action: #selector(loginBarItemDidClick))
        
        
        vistorView.registerBtn.addTarget(self, action: #selector(registerBarItemDidClick), for: .touchUpInside)
        vistorView.loginBtn.addTarget(self, action: #selector(loginBarItemDidClick), for: .touchUpInside)
    }
}

extension JPBaseViewController {

    @objc fileprivate func registerBarItemDidClick() {
    
       print("注册按钮被点击")
    }
    
    @objc fileprivate func loginBarItemDidClick() {
        
        print("登录按钮按钮被点击")
    }
}
