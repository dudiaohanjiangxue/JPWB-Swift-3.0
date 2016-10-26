//
//  JPComposeViewController.swift
//  JPWB
//
//  Created by KC on 16/10/24.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class JPComposeViewController: UIViewController {
   //MARK: - 属性
    /**中间的标题*/
    fileprivate lazy var titleView: JPComposeTitleView = JPComposeTitleView()
    /**自定义textView*/
    @IBOutlet weak var coustomTextView: JPComposeTextView!
    /**工具条*/
    @IBOutlet weak var toolBar: UIToolbar!
    /**工具条的底部约束*/
    @IBOutlet weak var toolViewBottomConst: NSLayoutConstraint!
    
    lazy var picpickerVc: JPPicPickerViewController = JPPicPickerViewController(collectionViewLayout: JPPicpickerViewLayout())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.初始设置
         setupUI()
        //2.添加键盘的监听
        addKeyboardNotification()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coustomTextView.becomeFirstResponder()
    }
    
    
    deinit {
        //移除键盘监听
        removeKeyboardNotification()
    }

    

    

}

//MARK: - 初始设置
extension JPComposeViewController {
    ///初始设置UI
    fileprivate func setupUI() {
        //1.导航条
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancalCompose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(sureCompose))
        navigationItem.rightBarButtonItem?.isEnabled = false
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 36)
        navigationItem.titleView = titleView
        
        //2.工具条地步的View
        addChildViewController(picpickerVc)
        self.view.insertSubview(picpickerVc.view, belowSubview: toolBar)
        picpickerVc.view.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0)
        }
    
    }
    //添加键盘的弹出
    fileprivate func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: .UIKeyboardWillChangeFrame, object: nil)
    
    }
    //移除监听
    fileprivate func removeKeyboardNotification() {
      NotificationCenter.default.removeObserver(self)
    
    }


}

//MARK: - 点击事件
extension JPComposeViewController: NVActivityIndicatorViewable {
    ///取消发布事件
    @objc fileprivate func cancalCompose() {
    
     dismiss(animated: true, completion: nil)
    }
    
    ///发布点击事件
    @objc fileprivate func sureCompose() {
        self.startAnimating(nil, message: "正在发布...", type: .ballSpinFadeLoader, color: .green, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        
      let text = coustomTextView.text ?? ""
        let image = picpickerVc.images.first
        if image != nil {
            
            JPHTTPRequestTool.shared.requestToComposeImageStatus(pic: image!, text: text, finished: { (response, isSuccess) in
                if isSuccess {
                    JPPrint("发布成功")
                }else{
                    JPPrint("发布失败")
                }
                self.stopAnimating()
            })
        }else {
        
            JPHTTPRequestTool.shared.requestToComposeTextStatus(text: text) { (_, isSuccess) in
                if isSuccess {
                    JPPrint("发布成功")
                }else{
                    JPPrint("发布失败")
                }
                self.stopAnimating()
            }
        }
      dismiss(animated: true, completion: nil)
    }
    
    ///键盘的frame即将改变
    @objc fileprivate func keyboardWillChangeFrame(note: Notification) {
    //name = UIKeyboardWillChangeFrameNotification, object = nil, 
       // userInfo = Optional([AnyHashable("UIKeyboardCenterBeginUserInfoKey"): NSPoint: {207, 849}, AnyHashable("UIKeyboardIsLocalUserInfoKey"): 1, AnyHashable("UIKeyboardCenterEndUserInfoKey"): NSPoint: {207, 623}, AnyHashable("UIKeyboardBoundsUserInfoKey"): NSRect: {{0, 0}, {414, 226}}, AnyHashable("UIKeyboardFrameEndUserInfoKey"): NSRect: {{0, 510}, {414, 226}}, AnyHashable("UIKeyboardAnimationCurveUserInfoKey"): 7, AnyHashable("UIKeyboardFrameBeginUserInfoKey"): NSRect: {{0, 736}, {414, 226}}, AnyHashable("UIKeyboardAnimationDurationUserInfoKey"): 0.4])]
        let endFrameValue = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let endFrame = endFrameValue.cgRectValue
        let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let bottomConst = UIScreen.main.bounds.height - endFrame.origin.y
        
        toolViewBottomConst.constant = bottomConst
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    ///选择照片按钮的点击
    @IBAction func picPickerBtnClick() {
     coustomTextView.resignFirstResponder()
        picpickerVc.view.snp.remakeConstraints { (make) in
            make.leading.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.65)
        }
        
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
        
    }
}
//MARK: - textView的代理方法
extension JPComposeViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        coustomTextView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        
        JPPrint(textView.isScrollEnabled)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        coustomTextView.resignFirstResponder()
    }
    

}
