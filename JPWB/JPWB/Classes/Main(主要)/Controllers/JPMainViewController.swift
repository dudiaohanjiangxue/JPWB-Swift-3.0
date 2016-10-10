//
//  JPMainViewController.swift
//  JPWB-Swift 3.0
//
//  Created by KC on 16/10/10.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}


//MARK: - json创建控制器
/*
 fileprivate func loadChildViewControllerJsonData() {
 //1.读取json数据
 guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
 print("获取路径不成功")
 return
 }
 
 guard let jsonData = NSData.init(contentsOfFile: jsonPath)  else {
 print("读取json数据不成功")
 return
 }
 
 guard let result = try? JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
 return
 }
 
 guard let dictArray = result as? [[String : AnyObject]] else {
 return
 }
 
 for dict in dictArray {
 guard let vcName = dict["vcName"] as? String else {
 continue
 }
 guard let title = dict["title"] as? String else {
 continue
 }
 guard let imageName = dict["imageName"] as? String else {
 continue
 }
 //添加控制器
 addChildViewController(vcName: vcName, title: title, imageName: imageName)
 }
 
 }
 
 fileprivate func addChildViewController(vcName : String, title: String, imageName: String) {
 
 guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
 print("没有获取到命名空间")
 return
 }
 print(nameSpace)
 guard let AnyClass = NSClassFromString(nameSpace + "." + vcName) else {
 print("没有创建出来对应的类")
 return
 }
 guard let vcClass = AnyClass as? UIViewController.Type  else {
 return
 }
 print(vcClass)
 let childVC = vcClass.init()
 childVC.title = title
 childVC.tabBarItem.image = UIImage.init(named: imageName)
 childVC.tabBarItem.selectedImage = UIImage.init(named: imageName + "_highlighted")
 
 let childNav = UINavigationController.init(rootViewController: childVC)
 self.addChildViewController(childNav)
 }

 */
