//
//  VerifyViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/28.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class VerifyViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var customTitle: UILabel!
    @IBOutlet weak var verifyView: VerifyTextField!
    var phoneNum:String?
    var languageDic:NSDictionary?
    var count = 0
    
    @IBAction func backBtnDidClick(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextBtnDidClick(_ sender: Any) {
        self.performSegue(withIdentifier: "setNewPwdPush", sender: nil)
    }
    
    @IBAction func tapToHideKeyboard(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertLabel.text = self.phoneNum//"输入尾号为 " +  (phoneNum?.substring(from: (phoneNum?.index((phoneNum?.endIndex)!, offsetBy: -4))!))! + " 的手机获得的验证码"
        self.backBtn.setAttributedTitle(Helpers.addDownLine("返回登录", font: self.backBtn.titleLabel!.font,color: UIColor.white), for: .normal)
        self.nextBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
        self.nextBtn.layer.borderWidth = 1
        self.nextBtn.layer.cornerRadius = 4
        
        if languageDic != nil {
            self.customTitle.text = self.languageDic?["text_verifyid"] as? String
            self.alertLabel.text = self.languageDic?["text_input"] as? String
            self.verifyView.placeholder = self.languageDic?["text_username"] as? String
            self.verifyView.btn?.setTitle(self.languageDic?["text_sendcode"] as? String, for: .normal)
            self.nextBtn.setTitle(self.languageDic?["text_next"] as? String, for: .normal)
            self.backBtn.setAttributedTitle(Helpers.addDownLine((self.languageDic?["text_backtologin"] as? String)!, font:self.backBtn.titleLabel!.font,color: UIColor.white), for: .normal)
        }
        self.verifyView.btn?.addTarget(self, action: #selector(requestSendCode), for: .touchUpInside)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newPwd = segue.destination as! SetNewPwdViewController
        newPwd.phoneNum = self.phoneNum
        newPwd.languageDic = self.languageDic
    }
    
    func reckonByTime(time:Timer) -> Void {
        count = count - 1
        if count >= 0 {
            self.verifyView.btn?.setTitle(String(count) + "s", for: .normal)
        }else{
            time.invalidate()
            self.verifyView.btn?.isEnabled = true
            if languageDic != nil {
                self.verifyView.btn?.setTitle(self.languageDic?["text_sendcode"] as? String, for: .normal)
            }else{
                self.verifyView.btn?.setTitle("发送验证码", for: .normal)
            }
        }
    }
    
    func requestSendCode() {
        count = 60
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reckonByTime(time:)), userInfo: nil, repeats: true)
        
        self.verifyView.btn?.isEnabled = false
//        NetworkModel.init(with: [:], url: "index.php?route=common/login/enterSecurityCode", requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
//            
//        }, failure: { (request) in
//            
//        })
    }
    
    func requestSendVerfiy() {
        if self.verifyView.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "")
            return
        }
        NetworkModel.init(with: ["verification":self.verifyView.text ?? ""], url: "index.php?route=common/login/validateSecurityCode", requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            
        }, failure: { (request) in
            SVProgressHUD.dismiss()
        })
    }
    
}
