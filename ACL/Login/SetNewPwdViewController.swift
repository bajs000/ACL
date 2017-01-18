//
//  SetNewPwdViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/28.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class SetNewPwdViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet weak var customTitle: UILabel!
    @IBOutlet weak var customDetail1: UILabel!
    @IBOutlet weak var customDetail2: UILabel!
    @IBOutlet weak var pwdTextField: PhoneTextField!
    @IBOutlet weak var surePwdTextField: PhoneTextField!
    var phoneNum:String?
    var languageDic:NSDictionary?
    
    @IBAction func topToHideKeyboard(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction func nextBtnDidClick(_ sender: Any) {
        self.requestNewPwd()
        self.performSegue(withIdentifier: "successPush", sender: nil)
    }
    
    @IBAction func backBtnDidClick(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = "返回登录"
        let tempStr:NSMutableAttributedString = NSMutableAttributedString.init(string: "返回登录")
        let range = NSMakeRange(0, title.characters.count)
        let attrs = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName : UIColor.white,
            NSUnderlineStyleAttributeName : 1] as [String : Any]
        tempStr.addAttributes(attrs, range: range)
        
        self.backBtn.setAttributedTitle(tempStr, for: .normal)
        self.nextBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
        self.nextBtn.layer.borderWidth = 1
        self.nextBtn.layer.cornerRadius = 4
        
        if languageDic != nil {
            self.customTitle.text = self.languageDic?["text_setnewpsw"] as? String
            self.customDetail1.text = self.languageDic?["text_setnewpsw"] as? String
            self.customDetail2.text = self.languageDic?["text_confirmnewpsw"] as? String
            self.nextBtn.setTitle(self.languageDic?["text_next"] as? String, for: .normal)
            self.backBtn.setAttributedTitle(Helpers.addDownLine((self.languageDic?["text_backtologin"] as? String)!,font:self.backBtn.titleLabel!.font,color: UIColor.white), for: .normal)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShow(_ notification:Notification) -> Void {
        let keyboardRect:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.bgViewTop.constant = -keyboardRect.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(_ notification:Notification) -> Void {
        UIView.animate(withDuration: 0.75, animations: ({
            self.bgViewTop.constant = 0
            self.view.layoutIfNeeded()
        }), completion: {(_ finish:Bool) -> Void in
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let update = segue.destination as! UpdateResultViewController
        update.languageDic = self.languageDic
    }
    
    func requestNewPwd() {
        SVProgressHUD.show()
        NetworkModel.init(with: ["new_password":self.pwdTextField.text ?? "","new_confirm":self.surePwdTextField.text ?? ""], url: "index.php?route=account/reset", requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            
        }, failure: { (request) in
            SVProgressHUD.dismiss()
        })
    }
}
