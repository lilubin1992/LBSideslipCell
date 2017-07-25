//
//  ZYXActionButton.swift
//  LBCustomCellProject
//
//  Created by ZhanyaaLi on 2017/7/21.
//  Copyright © 2017年 Hangzhou Zhanya Technology. All rights reserved.
//

import UIKit

class ZYXActionButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: 0, y: self.frame.size.height - 29, width: frame.size.width, height: 14)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageWidth : CGFloat = 24
        return CGRect.init(x: self.frame.size.width / 2 - imageWidth / 2, y: 16, width: imageWidth, height: imageWidth)
    }

}
