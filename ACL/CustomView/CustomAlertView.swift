//
//  CustomAlertView.swift
//  ACL
//
//  Created by YunTu on 2016/11/29.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit

class CustomAlertView: UIView {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var alertViewHeight: NSLayoutConstraint!
    @IBOutlet weak var alertViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    
    var complete:((UIButton?) -> Void)?
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        self.dismissBtnDidClick(nil)
        if  self.complete != nil {
            self.complete!(sender as? UIButton)
        }
    }
    
    @IBAction func dismissBtnDidClick(_ sender: Any?) {
        self.removeFromSuperview()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.alertView.layer.cornerRadius = 6
        let btn = self.alertView.viewWithTag(9)
        if btn != nil {
            btn?.layer.cornerRadius = 4
        }
        let textField = self.alertView.viewWithTag(8)
        if textField != nil {
            (textField as! UITextField).addTarget(self, action: #selector(editDidChange(_:)), for: .editingChanged)
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: ({
            self.alertView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }), completion: {(_ finish:Bool) -> Void in
            UIView.animate(withDuration: 0.23, delay: 0, options: .curveEaseInOut, animations: ({
                self.alertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }), completion: {(_ finish:Bool) -> Void in
                UIView.animate(withDuration: 0.09, delay: 0.02, options: .curveEaseInOut, animations: ({
                    self.alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }), completion: {(_ finish:Bool) -> Void in
                    UIView.animate(withDuration: 0.05, delay: 0.02, options: .curveEaseInOut, animations: ({
                        self.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }), completion: {(_ finish:Bool) -> Void in
                        
                    })
                })
            })
        })
    }
    
    func editDidChange(_ sender:UITextField) -> Void {
        if (sender.text?.characters.count)! > 8 {
            sender.text = sender.text?.substring(to: (sender.text?.index((sender.text?.startIndex)!, offsetBy: 8))!)
        }
    }
    
    func showMoney(title:String,moneyTitle:String,detail:String,sureTitle:String,cancelTitle:String,block:((UIButton?) -> Void)?) -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let screenHeight = UIScreen.main.bounds.size.height
        let rect = (detail as NSString).boundingRect(with: CGSize(width: 283 - 30, height:screenHeight - 30 - 63 ), options: [.usesLineFragmentOrigin , .usesFontLeading , .truncatesLastVisibleLine], attributes: [NSFontAttributeName:detailLabel.font], context: nil)
        var height = 42 + 15 + 16 + 15 + 15 + 23 + 25 + 5
        height = height + Int(rect.size.height)
        self.alertViewHeight.constant = CGFloat(height)
        self.detailLabel.text = detail
        self.titleLabel.text = title
        let btn = self.alertView.viewWithTag(9) as! UIButton
        btn.setTitle(sureTitle, for: .normal)
        let label = self.alertView.viewWithTag(99) as! UILabel
        label.text = moneyTitle
        self.complete = block
        
        self.showAlertOnWindow()
    }
    
    func showNotice(title:String,detail:String) -> Void {
        let screenHeight = UIScreen.main.bounds.size.height
        let rect = (detail as NSString).boundingRect(with: CGSize(width: 283 - 30, height:screenHeight - 102 ), options: [.usesLineFragmentOrigin , .usesFontLeading , .truncatesLastVisibleLine], attributes: [NSFontAttributeName:detailLabel.font], context: nil)
        var height = 42 + 15 + 15 + 5
        height = height + Int(rect.size.height)
        self.alertViewHeight.constant = CGFloat(height)
        self.detailLabel.text = detail
        self.titleLabel.text = title
        
        self.showAlertOnWindow()
    }
    
    private func showAlertOnWindow() {
        let window:UIWindow = ((UIApplication.shared.delegate?.window)!)! as UIWindow
        self.frame = window.frame
        window.addSubview(self)
        window.bringSubview(toFront: self)
        self.layoutIfNeeded()
    }
    
    @objc private func keyboardShow(_ notification:Notification) -> Void {
        let keyboardRect:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.alertViewCenterY.constant = -keyboardRect.size.height/2
            self.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardHide(_ notification:Notification) -> Void {
        UIView.animate(withDuration: 0.75, animations: ({
            self.alertViewCenterY.constant = 0
            self.layoutIfNeeded()
        }), completion: {(_ finish:Bool) -> Void in
            
        })
    }
    
}
