//
//  EmoticonViewController.swift
//  emoticon
//
//  Created by KC on 16/10/28.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
private let collectViewCellID = "collectViewCellID"
class EmoticonViewController: UIViewController {

    //MARK: - 属性
    ///表情的内容
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    ///表情标题栏
    fileprivate lazy var toolBar: UIToolbar = UIToolbar()
    ///表情数据
    fileprivate lazy var packageManager: PackageManager = PackageManager()
    ///选择了表情的回调
   fileprivate var callBack: ((_ emoticon: Emoticon) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupUI()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(callBack: @escaping (_ emoticon: Emoticon) -> ()) {
        self.callBack = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: -  UI界面
extension EmoticonViewController {

    fileprivate func setupUI() {
    //1.添加控件
        view.addSubview(toolBar)
        view.addSubview(collectionView)
        //2. 这是Frame
        collectionView.backgroundColor = UIColor.blue
        toolBar.backgroundColor = UIColor.lightGray
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["toolBar": toolBar, "collectionView": collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar(44)]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        //3.准备collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: collectViewCellID)
        //准备toolBar
        prepareFortoolBar()
    }
    
    private func prepareFortoolBar() {
        //1.自定义标题
    let titles = ["最近", "默认", "Emoji", "浪小花"]
        //2.添加items
        var items = [UIBarButtonItem]()
        
        for i in 0..<titles .count{
            let item = UIBarButtonItem(title: titles[i], style: .plain, target: self, action: #selector(itemDidClick(item:)))
            item.tag = i
            item.tintColor = UIColor.orange
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    
    }
    
    @objc private func itemDidClick(item: UIBarButtonItem) {
        let indexPath = IndexPath(item: 0, section: item.tag)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    
    }
 
}

extension EmoticonViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //1.取出点击的数据模型
        let emoticonPackages = packageManager.emoticonPackages[indexPath.section]
        let emoticon = emoticonPackages.emoticons[indexPath.item]
        ///插入最近表情
        insertRecentlyEmoticon(emoticon: emoticon)
        ///回调表情出去
        if callBack != nil {
            
            callBack!(emoticon)
        }
        
    }
    
    ///插入表情
    private func insertRecentlyEmoticon(emoticon: Emoticon) {
    
        if emoticon.isEmpty || emoticon.isRemove {
            return
        }
       
        
        if packageManager.emoticonPackages[0].emoticons.contains(emoticon) {//如果包含在最近的数组里,先移除再添加
            let index = packageManager.emoticonPackages[0].emoticons.index(of: emoticon)
            packageManager.emoticonPackages[0].emoticons.remove(at: index!)
           
        }else {//没包含,就移除最后一个,再添加
            packageManager.emoticonPackages[0].emoticons.remove(at: 19)
            
        }
        //插入表情
        
        packageManager.emoticonPackages[0].emoticons.insert(emoticon, at: 0)
        
    }


}

//MARK: - UICollectionViewDataSource
extension EmoticonViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return packageManager.emoticonPackages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let emoticonPackages = packageManager.emoticonPackages[section]
        return emoticonPackages.emoticons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emoticonPackages = packageManager.emoticonPackages[indexPath.section]
        let emoticon = emoticonPackages.emoticons[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectViewCellID, for: indexPath) as! EmoticonViewCell
        cell.emoticon = emoticon
    
        return cell
    }
}


//MARK: - collectionViewLayOut
class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        let cols: CGFloat = 7
        let imageWH = UIScreen.main.bounds.width / cols
        itemSize = CGSize(width: imageWH, height: imageWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        let insetMargin = (collectionView!.bounds.height - 3 * imageWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}

