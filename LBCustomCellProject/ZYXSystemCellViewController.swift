//
//  ZYXSystemCellViewController.swift
//  LBCustomCellProject
//
//  Created by lilubin on 2017/7/28.
//  Copyright © 2017年 Hangzhou Zhanya Technology. All rights reserved.
//

import UIKit

fileprivate let kCellIdentifier = "ZYXSideslipSonCell"

class ZYXSystemCellViewController: UIViewController {
    
    lazy var tableView : UITableView = { [unowned self] in
        let tableView : UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), style: .grouped)
        tableView.separatorStyle = .singleLine
        tableView.alwaysBounceVertical = true
        tableView.rowHeight = 75
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellNib = UINib.init(nibName: "ZYXSideslipSonCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: kCellIdentifier)
        
        return tableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "系统自带的CELL"
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ZYXSystemCellViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! ZYXSideslipSonCell
        cell.backgroundColor = .orange
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action1 = UITableViewRowAction.init(style: .default, title: "标题1") { (action, actIndexpath) in
            print("---action 1---")
        }
        
        let action2 = UITableViewRowAction.init(style: .default, title: "标题2") { (action, actIndexPath) in
            print("---action 2---")
        }
        
        return [action1, action2]
    }
    
}
