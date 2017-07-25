//
//  ZYXInheritViewController.swift
//  LBCustomCellProject
//
//  Created by ZhanyaaLi on 2017/7/21.
//  Copyright © 2017年 Hangzhou Zhanya Technology. All rights reserved.
//

import UIKit

fileprivate let kCellIdentifier = "ZYXSideslipSonCell"

class ZYXInheritViewController: UIViewController {
    
    lazy var tableView : UITableView = { [unowned self] in
        let tableView : UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), style: .grouped)
        tableView.separatorStyle = .singleLine
        tableView.alwaysBounceVertical = true
        tableView.rowHeight = 75
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellNib = UINib.init(nibName: "ZYXSideslipSonCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: kCellIdentifier)
//        tableView.register(ZYXSideslipSonCell.self, forCellReuseIdentifier: kCellIdentifier)
        
        return tableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "继承关系的CELL"
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension ZYXInheritViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! ZYXSideslipSonCell
        cell.backgroundColor = .orange
        cell.delegate = self
        return cell
    }
}

extension ZYXInheritViewController : ZYXSideslipCellDelegate {
    func sideslipCell(_ sideslipCell: ZYXSideslipCell, editActionsForRowAt indexPath: IndexPath) -> [ZYXSideslipCellAction]? {
        let action1 : ZYXSideslipCellAction = ZYXSideslipCellAction.init(.normal, "电话") { (action, indexPath) in
            print("---点击第一个按钮---")
        }
        action1.image = #imageLiteral(resourceName: "phoneIcon")
        action1.backgroundColor = UIColor.init(red: 255.0 / 255.0, green: 200.0 / 255.0, blue: 83.0 / 255.0, alpha: 1.0)
        action1.fontSize = 10
        action1.titleColor = .white

        let action2 : ZYXSideslipCellAction = ZYXSideslipCellAction.init(.normal, "短信") { (action, indexPath) in
            print("---点击第二个按钮---")
        }
        action2.image = #imageLiteral(resourceName: "messageIcon")
        action2.backgroundColor = UIColor.init(red: 83.0 / 255.0, green: 192.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        action2.fontSize = 10
        action2.titleColor = .white
        
        return [action1, action2]
    }
    
    func sideslipCell(_ sideslipCell: ZYXSideslipCell, canSideslipRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    /*
    func sideslipCell(_ sideslipCell: ZYXSideslipCell, cellRowAt indexPath: IndexPath, didSelectedAt index: Int) {
        
    }
     */
}












