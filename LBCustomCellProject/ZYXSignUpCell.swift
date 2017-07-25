//
//  ZYXSignUpCell.swift
//  xinAnSwift
//
//  Created by ZhanyaaLi on 2017/7/19.
//  Copyright © 2017年 Hangzhou Zhanya Technology. All rights reserved.
//

import UIKit

enum ZYXSignupCellActionStyle : Int {
    case defaultState = 0
    case destructive
    case normal
}

class ZYXSignupCellAction {
    
    var style : ZYXSignupCellActionStyle?
    
    var title : String?
    
    var image : UIImage?
    
    var fontSize : CGFloat = 10
    
    var titleColor : UIColor = .black
    
    var backgroundColor : UIColor = .gray
    
    var margin : CGFloat = 15
    
    typealias actionHandlerBlock = (_ action : ZYXSignupCellAction, _ indexPath : IndexPath)->()
    
    var handler : actionHandlerBlock?
    
    init(_ style : ZYXSignupCellActionStyle, _ title : String, _ handler : @escaping actionHandlerBlock) {
        self.title = title
        self.handler = handler
        self.style = style
    }
    
}

protocol ZYXSignupCellDelegate : NSObjectProtocol {
    
    /// 选中了侧滑按钮
    ///
    /// - Parameters:
    ///   - sideslipCell: 当前响应的cell
    ///   - indexPath: cell在tableview中的位置
    ///   - index: 选中的第几个action
    func sideslipCell(_ sideslipCell : ZYXSignUpCell, cellRowAt indexPath : IndexPath, didSelectedAt index : Int) -> Void
    
    
    /// 告知当前位置的cell是否需要侧滑按钮
    ///
    /// - Parameters:
    ///   - sideslipCell: 当前响应的cell
    ///   - indexPath: cell在tablev中的位置
    /// - Returns: true 表示可以侧滑， false 表示不可以
    func sideslipCell(_ sideslipCell : ZYXSignUpCell, canSideslipRowAt indexPath : IndexPath) -> Bool
    
    
    /// 返回侧滑事件
    ///
    /// - Parameters:
    ///   - sideslipCell: 当前响应的cell
    ///   - indexPath: cell在tableview中的位置
    /// - Returns: 数组为空，则没有侧滑事件
    func sideslipCell(_ sideslipCell : ZYXSignUpCell, editActionsForRowAt indexPath : IndexPath) -> [ZYXSignupCellAction]?
}


enum ZYXSignupCellState {
    case normal
    case animating
    case open
}

class ZYXSignUpCell: UITableViewCell {
    
    open weak var delegate : ZYXSignupCellDelegate?
    
    var state : ZYXSignupCellState = .normal {
        didSet{
            switch state {
            case .normal:
//                self.tableView.isScrollEnabled = true
                self.tableView.allowsSelection = true
                for cell in self.tableView.visibleCells as! [ZYXSignUpCell] {
                    cell.sideslip = false
                }
            case .animating:
                break
            case .open:
//                self.tableView.isScrollEnabled = false
                self.tableView.allowsSelection = false
                for cell in self.tableView.visibleCells as! [ZYXSignUpCell] {
                    cell.sideslip = true
                }
            }
        }
    }
    
    var indexPath : IndexPath? {
        get {
            return tableView.indexPath(for: self)
        }
    }
    
    var actions : [ZYXSignupCellAction] = [ZYXSignupCellAction]() {
        didSet {
            
            self.insertSubview(btnContainerView, belowSubview: contentView)
            
            for index in 0..<actions.count {
                
                let action = actions[index]
                let btn1 : ZYXActionButton = ZYXActionButton.init(type: .custom)
                btn1.adjustsImageWhenHighlighted = false
                btn1.frame = CGRect.init(x: index * 70, y: 0, width: 70, height: Int(self.frame.size.height))
                btn1.setImage(action.image, for: .normal)
                btn1.setTitle(action.title, for: .normal)
                btn1.titleLabel?.font = UIFont.systemFont(ofSize: action.fontSize)
                btn1.titleLabel?.textAlignment = .center
                btn1.setTitleColor(action.titleColor, for: .normal)
                btn1.backgroundColor = action.backgroundColor
                btn1.tag = 100 + index
                btn1.addTarget(self, action: #selector(actionBtnDidClicked(_:)), for: .touchUpInside)
                btnContainerView.addSubview(btn1)

            }
        }
    }
    
    func actionBtnDidClicked(_ btn : UIButton) {
        delegate?.sideslipCell(self, cellRowAt: self.indexPath!, didSelectedAt: btn.tag - 100)
        if btn.tag - 100 < actions.count {
            let action = actions[btn.tag - 100]
            if nil != action.handler {
                action.handler!(action, self.indexPath!)
            }
            self.state = .normal
        }
    }
    
    var panGesture : UIPanGestureRecognizer?
    
//    var tableViewPan : UIPanGestureRecognizer?
    
    //侧滑状态 true: 开启状态   false:关闭状态
    var sideslip : Bool = false
    
    lazy var tableView : UITableView = {[unowned self] in
        var view = self.superview
        while (view != nil) && view?.isKind(of: UITableView.self) == false {
            view = view?.superview
        }
//        self.tableViewPan = UIPanGestureRecognizer.init(target: self, action: #selector(tableViewPan(_:)))
//        self.tableViewPan?.delegate = self
//        view?.addGestureRecognizer(self.tableViewPan!)
        return view as! UITableView
        }()
    
    lazy var btnContainerView : UIView = {
        let view : UIView = UIView.init(frame: CGRect.init(x: kScreenWidth - 140, y: 0, width: 140, height: self.frame.size.height))
        view.backgroundColor = .orange
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addPanGesture()
//        self.insertSubview(btnContainerView, belowSubview: contentView)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        var x : CGFloat = 0
        if sideslip {
            x = contentView.frame.origin.x
        }
        print("---ZYXSideslipCell layoutSubviews")
        super.layoutSubviews()
        
        if sideslip {
            self.setContentViewX(x)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if sideslip {
            self.hiddenAllSideslip()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if sideslip {
            self.hiddenSideslip()
        }
    }
    
    func addPanGesture() {
        print("---ADD PANGESTURE---")
        contentView.isUserInteractionEnabled = true
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(contentViewPan(_:)))
        panGesture!.delegate = self
        contentView.addGestureRecognizer(panGesture!)
    }
    
    func contentViewPan(_ pan : UIPanGestureRecognizer) {
        
        let point : CGPoint = pan.translation(in: pan.view)
        print("---contentViewPan point:(\(point.x), \(point.y))--")
        let state = pan.state
        pan.setTranslation(.zero, in: pan.view)
        if state == .changed {
            var frame = self.contentView.frame
            frame.origin.x += point.x
            if frame.origin.x > 15 {
                frame.origin.x = 15
            }
            else if frame.origin.x < -30 - btnContainerView.frame.size.width {
                frame.origin.x = -30 - btnContainerView.frame.size.width
            }
            contentView.frame = frame
        }
        else if state == .ended {
            let velocity = pan.velocity(in: pan.view)
            if contentView.frame.origin.x == 0 {
                return
            }
            else if contentView.frame.origin.x > 5 {
                self.hiddenWithBounceAnimation()
            }
            else if fabs(contentView.frame.origin.x) >= 40 && velocity.x <= 0 {
                self.showSideslip()
            }
            else {
                self.hiddenSideslip()
            }
        }
        else if state == .cancelled {
            self.hiddenAllSideslip()
        }
    }
    /*
    func tableViewPan(_ pan : UIPanGestureRecognizer) {
        if !tableView.isScrollEnabled && pan.state == .began {
            self.hiddenAllSideslip()
        }
    }
    */
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //处理添加手势后 与 tableView 滑动矛盾的问题
        if gestureRecognizer == panGesture! {
            
            if !self.tableView.isScrollEnabled {
                self.hiddenAllSideslip()
                return false
            }
            
            let gesture : UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let translation : CGPoint = gesture.translation(in: gesture.view)
            print("----translation:(\(translation.x), \(translation.y))")
            var shouldBegin : Bool = fabs(translation.y) <= fabs(translation.x)
            
            if !shouldBegin {
                self.hiddenAllSideslip()
                return false
            }
            else {
                //使用contentview的frame来判断是否是滑动当前的cell
                if sideslip && self.contentView.frame.origin.x == 0 {
                    self.hiddenAllSideslip()
                }
            }
            //询问是否需要侧滑
            shouldBegin = (delegate?.sideslipCell(self, canSideslipRowAt: self.indexPath!))! || sideslip
            
            if shouldBegin {
                let curActions : [ZYXSignupCellAction] = (delegate?.sideslipCell(self, editActionsForRowAt: self.indexPath!))!
                if curActions.count == 0 {
                    return false
                }
                if self.actions.count == 0 {
                    self.actions = curActions
                }
            }
            else {
                return false
            }
            return shouldBegin

        }
        /*
        else if gestureRecognizer == tableViewPan! {
            if tableView.isScrollEnabled {
                return false
            }
        }
         */
        return true
    }
    
    
}

extension ZYXSignUpCell {
    
    func setContentViewX(_ x : CGFloat) {
        var frame : CGRect = self.contentView.frame
        frame.origin.x = x
        contentView.frame = frame
    }
    
    //MARK: - Animate method
    func hiddenWithBounceAnimation() {
        state = .animating
        UIView.animate(withDuration: 0.25, animations: {
            self.setContentViewX(-10)
        }) { (finished) in
            self.hiddenSideslip()
        }
    }
    
    
    func hiddenAllSideslip() {
        tableView.hiddenAllSignupSideslip()
    }
    
    func hiddenSideslip() {
        if contentView.frame.origin.x == 0 {
            return
        }
        
        state = .animating
        UIView.animate(withDuration: 0.2, animations: {
            self.setContentViewX(0)
        }) { (finished) in
            
//            for subView in self.btnContainerView.subviews {
//                subView.removeFromSuperview()
//            }
            self.state = .normal
        }
    }
    
    func showSideslip() {
        state = .animating
        UIView.animate(withDuration: 0.2, animations: {
            self.setContentViewX(-self.btnContainerView.frame.size.width)
        }) { (finished) in
            self.state = .open
        }
    }
    
}


extension UITableView {
    func hiddenAllSignupSideslip() {
        for cell in self.visibleCells as! [ZYXSignUpCell] {
            cell.hiddenSideslip()
        }
    }
}





















