//
//  JPWelcomeViewController.swift
//  JPWB
//
//  Created by KC on 16/10/18.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import Kingfisher
class JPWelcomeViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var screen_name: UILabel!
    @IBOutlet weak var iconViewTopConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let imageUrl =  URL(string: JPuserAccountViewModel.shared.account?.avatar_large ?? "")
        iconView.kf.setImage(with: imageUrl)
        screen_name.text = JPuserAccountViewModel.shared.account?.screen_name ?? "欢迎回来"
        //动画
        iconViewTopConst.constant = 100
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }) { (_) in
                UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
