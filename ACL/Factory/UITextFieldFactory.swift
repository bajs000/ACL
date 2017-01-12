//
//  UITextField+Factory.swift
//  ACL
//
//  Created by YunTu on 2016/11/28.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit

class UITextFieldFactory: UITextField {
    
    @IBInspectable var left:CGFloat = 0.0
    @IBInspectable var right:CGFloat = 0.0
    @IBInspectable var placeholderColor:UIColor = UIColor.white
    var placeholderLabel:UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.placeholderLabel = UILabel.init(frame: CGRect(x: left, y: 0, width: 100, height: self.bounds.size.height))
        self.addSubview(self.placeholderLabel!)
        self.placeholderLabel?.text = self.placeholder
        self.placeholderLabel?.textColor = placeholderColor
        self.placeholderLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addTarget(self, action: #selector(editDidChange(_:)), for: .editingChanged)
    }
    
    override var placeholder: String?{
        didSet{
            self.placeholderLabel?.text = placeholder
            if self.text == nil || self.text?.characters.count == 0 {
                self.placeholderLabel?.isHidden = false
            }else{
                self.placeholderLabel?.isHidden = true
            }
        }
    }
    
    override func borderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
    }
    
    func editDidChange(_ sender:UITextField) -> Void {
        if sender.text?.characters.count == 0 {
            self.placeholderLabel?.isHidden = false
        }else{
            self.placeholderLabel?.isHidden = true
        }
    }
}

class PhoneTextField: UITextFieldFactory {
    
    @IBInspectable var length:Int = 11
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
        
        self.addTarget(self, action: #selector(editDidChange), for: .editingChanged)
    }
    
    override func editDidChange(_ sender:UITextField) -> Void {
        super.editDidChange(sender)
        if (sender.text?.characters.count)! > length {
            sender.text = sender.text?.substring(to: (sender.text?.index((sender.text?.startIndex)!, offsetBy: length))!)
        }
    }
}

class CodeTextField: UITextFieldFactory {
    
    var code:String = ""
    var codeView:PooCodeView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
        
        self.addTarget(self, action: #selector(editDidChange), for: .editingChanged)
        
        codeView = PooCodeView.init(frame: CGRect(x: 0, y: 1, width: 90, height: 46))
//        self.addSubview(codeView!)
        self.rightView = codeView
        self.rightViewMode = .always
        code = (codeView?.code)!
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapToChangeCode))
        self.addGestureRecognizer(tap)
        
    }
    
    override func editDidChange(_ sender:UITextField) -> Void {
        super.editDidChange(sender)
        if (sender.text?.characters.count)! > 4 {
            sender.text = sender.text?.substring(to: (sender.text?.index((sender.text?.startIndex)!, offsetBy: 4))!)
        }
    }
    
    func tapToChangeCode() -> Void {
        self.code = (codeView?.changeCode())!
    }
    
}

class VerifyTextField: UITextFieldFactory {
    
    var btn:UIButton? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
        
        self.addTarget(self, action: #selector(editDidChange), for: .editingChanged)
        
        let bg = UIView.init(frame: CGRect(x: 0, y: 0, width: 128, height: self.bounds.size.height))
        bg.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        self.rightView = bg
        self.rightViewMode = .always
        
        self.btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: bg.frame.size.width, height: self.frame.size.height))
        bg.addSubview(self.btn!)
        self.btn!.setTitle("发送验证码", for: .normal)
        self.btn!.setTitleColor(UIColor(red: 64.0/255.0, green: 65/255.0, blue: 70/255.0, alpha: 1), for: .normal)
        self.btn!.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        self.btn!.addTarget(self, action: #selector(verifyBtnDidClick(_:)), for: .touchUpInside)
    }
    
    override func editDidChange(_ sender:UITextField) -> Void {
        super.editDidChange(sender)
        if (sender.text?.characters.count)! > 4 {
            sender.text = sender.text?.substring(to: (sender.text?.index((sender.text?.startIndex)!, offsetBy: 4))!)
        }
    }
    
    func verifyBtnDidClick(_ sender:UIButton) -> Void {
        print("111")
    }
    
}
