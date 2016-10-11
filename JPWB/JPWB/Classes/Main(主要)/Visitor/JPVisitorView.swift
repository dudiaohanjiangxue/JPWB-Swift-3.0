//
//  JPVisitorView.swift
//  JPWB
//
//  Created by KC on 16/10/11.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPVisitorView: UIView {
    //MARK: - 懒加载
    class func visitorView() -> JPVisitorView {
     
        return Bundle.main.loadNibNamed("JPVisitorView", owner: nil, options: nil)!.first as! JPVisitorView
    
    }
   //MARK: - 属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //设置空间的内容
    func setupVisitorViewInfo(iconName: String, tipString: String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = tipString
        rotationView.isHidden = true
    }
    
    
    ///给转盘添加动画
    func addRotationAnmation()  {
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 10
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.isRemovedOnCompletion = false
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
}
