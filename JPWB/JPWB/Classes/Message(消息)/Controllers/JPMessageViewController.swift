//
//  JPMessageViewController.swift
//  JPWB-Swift 3.0
//
//  Created by KC on 16/10/10.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPMessageViewController: JPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        vistorView.setupVisitorViewInfo(iconName: "visitordiscover_image_message", tipString: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
