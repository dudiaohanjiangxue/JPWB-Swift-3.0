//
//  JPProfileViewController.swift
//  JPWB-Swift 3.0
//
//  Created by KC on 16/10/10.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPProfileViewController: JPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

         vistorView.setupVisitorViewInfo(iconName: "visitordiscover_image_profile", tipString: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
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
