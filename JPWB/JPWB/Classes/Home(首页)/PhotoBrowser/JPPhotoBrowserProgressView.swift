//
//  JPPhotoBrowserProgressView.swift
//  JPWB
//
//  Created by KC on 16/10/31.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPPhotoBrowserProgressView: UIView {
    
    var progress: CGFloat = 0 {
        didSet {
        setNeedsDisplay()
        
        }
    
    }
    
  //MARK: - 重写drawRect方法
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //画出下载进度的圆
       let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(M_PI_2) * progress + startAngle
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        bezierPath.addLine(to: center)
        bezierPath.close()
        UIColor(white: 0.9, alpha: 0.4).setFill()
        
        bezierPath.fill()
    }

}
