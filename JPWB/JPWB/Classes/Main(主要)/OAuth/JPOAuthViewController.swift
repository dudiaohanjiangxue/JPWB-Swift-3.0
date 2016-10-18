//
//  JPOAuthViewController.swift
//  JPWB
//
//  Created by KC on 16/10/14.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView
import SwiftyJSON

class JPOAuthViewController: UIViewController {
    //MARK: - 懒加载
    lazy var oAuthView: WKWebView = {
        let oAuthView : WKWebView = WKWebView(frame: self.view.bounds)
        oAuthView.uiDelegate = self
        oAuthView.navigationDelegate = self
      
        return oAuthView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //1. 设置导航条items 
        setupNavItems()
        //2.添加webView
        view.addSubview(oAuthView)
        //3.加载授权页面
        guard let url =  URL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(OAuthInfo.app_key)&redirect_uri=\(OAuthInfo.redirect_uri)") else {
            return
        }
        print(url)
        oAuthView.load(URLRequest(url: url))
    }

    override func viewWillAppear(_ animated: Bool) {
        startAnimating(CGSize(width: 100, height: 100), message: "正在加载...", type: NVActivityIndicatorType.ballSpinFadeLoader, color: UIColor.red, padding: nil, displayTimeThreshold: 15, minimumDisplayTime: 3)
    }


}


//MARK: - UI
extension JPOAuthViewController {

    fileprivate func setupNavItems() {
       navigationItem.title = "新浪授权"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self
            , action: #selector(dismissController))
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self
            , action: #selector(wirteUserNameAndPassWord))
    }

}

//MARK: - WKUIDelegate
extension JPOAuthViewController: WKUIDelegate{

    
}

//MARK: - WKNavigationDelegate
extension JPOAuthViewController: WKNavigationDelegate,NVActivityIndicatorViewable {
    //1.刚开始加载时
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         print("didStartProvisionalNavigation")
        startAnimating(CGSize(width: 100, height: 100), message: "正在加载...", type: NVActivityIndicatorType.ballSpinFadeLoader, color: UIColor.red, padding: nil, displayTimeThreshold: 15, minimumDisplayTime: 3)
    }
    
    //开始返回内容时
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
         print("didCommit")
    }
    
    //加载失败时
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation")
        stopAnimating()
        startAnimating(CGSize(width: 50, height: 50), message: "请检查网络", type: NVActivityIndicatorType.ballZigZagDeflect, color: UIColor.green, padding: nil, displayTimeThreshold: 5, minimumDisplayTime: 2)
        
        DispatchQueue(label: "main").asyncAfter(deadline: DispatchTime.now(), execute: {
            
            self.stopAnimating()
        })
        
    }
    
    //加载完成时
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         print("didFinish")
        stopAnimating()
    }
    
    //接受到服务器跳转请求之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation")
        
    }
    
    //接受响应后,决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("decidePolicyFor")
        decisionHandler(.allow)
    }
    
    //发送请求之前,决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url?.absoluteString)
       
        let urlString = (navigationAction.request.url?.absoluteString)!
        guard urlString.contains("code=") else {
            decisionHandler(.allow)
            return
        }
        
        let code = urlString.components(separatedBy: "code=").last!
        
        
        requestToAccessTohen(code: code)
      
         decisionHandler(.cancel)
    }
    
   
}

//MARK: - 点击事件
extension JPOAuthViewController {

    @objc fileprivate func dismissController() {
          dismiss(animated: true, completion: nil)
    
    }
    
    ///填充用户名和密码
    @objc fileprivate func wirteUserNameAndPassWord() {
        let jsString = "document.getElementById('userId').value='15820723956';document.getElementById('passwd').value='900827chen';"
        oAuthView.evaluateJavaScript(jsString) { (data: Any?, error: Error?) in
            if error == nil {
             JPLog("填充成功")
            
            }
        }
        
    }
}


//MARK: - 自定义方法
extension JPOAuthViewController {
    fileprivate func requestToAccessTohen(code: String) {
        
      JPHTTPRequestTool.requestToAccessTohen(code: code) { response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            let userModel = JPUserAccount(dict: value as! [String: Any])
            JPLog(userModel)
        case .failure(let error):
            print(error)
       
            
        }
    
        
        }
        
        
    }

}
