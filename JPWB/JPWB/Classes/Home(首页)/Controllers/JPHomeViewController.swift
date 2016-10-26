//
//  JPHomeViewController.swift
//  JPWB-Swift 3.0
//
//  Created by KC on 16/10/10.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import MJRefresh

private let cellID = "ststusCellID"
class JPHomeViewController: JPBaseViewController {
    
    //MARK: - 懒加载
   fileprivate lazy var titleBtn: JPTitleButton = {
        let btn: JPTitleButton = JPTitleButton()
        btn.setTitle("陈锦彭", for: UIControlState())
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setImage(UIImage(named: "navigationbar_arrow_up"), for: .normal)
        btn.setImage(UIImage(named: "navigationbar_arrow_down"), for: .selected)
        btn.sizeToFit()
        return btn
    }()
    
    //MARK: - 属性
   fileprivate lazy var animationor : JPAnimationor = JPAnimationor()
    ///数据源
   fileprivate lazy var statuses: [JPStatusViewModel] = [JPStatusViewModel]()
    ///cell的高度
   fileprivate lazy var cellHeightCache: [String : CGFloat] = [String : CGFloat]()
    ///提示Label
   fileprivate lazy var tipLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.没有登录的页面
        if !isLogin{
            vistorView.addRotationAnmation()
            return
        }
        
        //2.登录的页面
        setupNavigationItem()
        
        //3.下拉刷新功能
        setupRefreshHeaderView()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
//MARK: -  UI的设置
extension JPHomeViewController {
    
    ///这只导航条的内容
    fileprivate func setupNavigationItem() {
     
        // 1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(leftItemClick))
        
        // 2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightItemClick))
        
        //3.中间的标题
         navigationItem.titleView = titleBtn
        titleBtn.addTarget(self, action: #selector(titleBtnClick(titleBtn:)), for: .touchUpInside)
    }
    
    ///设置下拉刷新
    fileprivate func setupRefreshHeaderView() {
        //1.设置刷新头
        let refreshHeaderView = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        refreshHeaderView?.setTitle("下拉刷新", for: .idle)
        refreshHeaderView?.setTitle("松开刷新", for: .pulling)
        refreshHeaderView?.setTitle("正在刷新", for: .refreshing)
        tableView.mj_header = refreshHeaderView
        //2.进入刷新的状态
        tableView.mj_header.beginRefreshing()
        
        //2.设置刷新Footer
        let refreshFooterView = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
            
        tableView.mj_footer = refreshFooterView
        
        //3.提示Label的设置
        setupTipLabel()
       
    }
    
    ///提示文字
    private func setupTipLabel() {
     navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        tipLabel.frame = CGRect(x: 0, y: 12, width: UIScreen.main.bounds.width, height: 32)
        tipLabel.textAlignment = .center
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textColor = UIColor.white
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.isHidden = true
    
    }
}

//MARK: - navgitBar的点击事件
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

//MARK: - 网络数据加载
extension JPHomeViewController {
    ///1.加载更多数据
    @objc fileprivate func loadNewData() {
       loadStatusesData(isNewData: true)
    
    }
    
    ///1.加载更多数据
    @objc fileprivate func loadMoreData() {
    
    loadStatusesData(isNewData: false)
    }

    private func loadStatusesData(isNewData: Bool) {
        var since_id: Int = 0
        var max_id: Int = 0
        
        if isNewData {
            since_id = statuses.first?.status?.id ?? 0
        }else {
            max_id = statuses.last?.status?.id ?? 0
            max_id = max_id == 0 ? 0 : max_id - 1
        }
        JPHTTPRequestTool.shared.requestUserStatuses(since_id: since_id, max_id: max_id) { (response, isSuccess) in
            switch isSuccess {
            case true :
                let jsonData = JSON(response)
                guard let dataArray = jsonData["statuses"].arrayObject as? [[String: Any]] else {
                    return
                }
                var statuses = [JPStatusViewModel]()//这次请求回来的数据
                for statusDict in dataArray {
                    
                    let statusModal = JPStatusModal(dict: statusDict)
                    let statusViewModal = JPStatusViewModel(status: statusModal)
                    statuses.append(statusViewModal)
                }
                if isNewData {
                
                    self.statuses = statuses + self.statuses//这次的数据加上以前的数据
                }else {
                    self.statuses += statuses
                
                }
                self.loadImagesToCache(modals: statuses)
                
                
                JPPrint(self.statuses[0].status)
                JPPrint(self.statuses.last?.status)
                break
            case false:
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                break
            }

        }
    }
    
    private func loadImagesToCache(modals: [JPStatusViewModel]) {
        
        let group = DispatchGroup()
        for statusViewModal in statuses {
            for imageUrl in statusViewModal.picURLs {
                group.enter()
                KingfisherManager.shared.retrieveImage(with: imageUrl, options: [], progressBlock: nil, completionHandler: { (_, _, _, _) in
                    group.leave()
                })
            }
            
        }
        
        group.notify(queue: DispatchQueue.main) { 
            JPPrint("刷新表格")
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.showTipLabel(count: modals.count)
            
        }
    
    }
    
}

//MARK: - tableVIew数据源方法
extension JPHomeViewController {
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let statusViewModal = statuses[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! JPHomeStatusCell
         cell.statusViewModal = statusViewModal
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statusViewModel = statuses[indexPath.row]
        //1.先到缓存里取
        var cellHeight: CGFloat? = cellHeightCache["\(statusViewModel.status?.id)"]
        //2.如果有值,直接返回
        if cellHeight != nil {
            return cellHeight!
        }
        //3.没有值,自己计算
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! JPHomeStatusCell
        cellHeight = cell.cellHeight(statusViewModal: statusViewModel)
        //4.保存到缓存中再返回
        cellHeightCache["\(statusViewModel.status?.id)"] = cellHeight!
        return cellHeight!
        
    }
    
}

//MARK: - 自定义方法
extension JPHomeViewController {

    fileprivate func showTipLabel(count: Int) {
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有更多微博了" : "更新了\(count)条微博"
        UIView.animate(withDuration: 1, animations: {
            self.tipLabel.frame.origin.y = 44
            }) { (_) in
                UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: { 
                    self.tipLabel.frame.origin.y = 12
                    }, completion: { (_) in
                        self.tipLabel.isHidden = true
                })
        }
    
    }
}

