//
//  UIViewFactory.swift
//  ACL
//
//  Created by YunTu on 2016/12/1.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit

class UIViewFactory: UIView {
    
    @IBInspectable var borderWidth:CGFloat = 1.0
    @IBInspectable var borderColor:UIColor = UIColor.RGB(red: 235.0, green: 235.0, blue: 235.0, alpha: 1)
    @IBInspectable var shadowColor:UIColor = UIColor.black
    @IBInspectable var shadowOffset:CGSize = CGSize(width: 0, height: 0)
    @IBInspectable var shadowOpacity:Float = 0.2
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class ShadowView: UIViewFactory {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowOpacity = self.shadowOpacity
    }
}
