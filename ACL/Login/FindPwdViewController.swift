//
//  FindPwdViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/28.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class FindPwdViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var phoneNumTextField: PhoneTextField!
    @IBOutlet weak var customTitle: UILabel!
    @IBOutlet weak var customDetail: UILabel!
    var languageDic:NSDictionary?
    
    @IBAction func backBtnDidClick(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapToHideKeyboard(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction func nextBtnDidClick(_ sender: Any) {
//        if self.phoneNumTextField.text?.characters.count == 0{
//            var str = "请正确输入手机号"
//            if UserDefaults.standard.object(forKey: "language") as? String == "en" {
//                str = self.languageDic?["text_input"] as! String
//            }
//            SVProgressHUD.showError(withStatus: str)
//        }else{
//            self.performSegue(withIdentifier: "verifyPush", sender: nil)
//        }
        self.requestUserName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backBtn.setAttributedTitle(Helpers.addDownLine("返回登录",font:self.backBtn.titleLabel!.font,color: UIColor.white), for: .normal)
        self.nextBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
        self.nextBtn.layer.borderWidth = 1
        self.nextBtn.layer.cornerRadius = 4
        if languageDic != nil {
            self.customTitle.text = self.languageDic?["text_findpsw"] as? String
            self.customDetail.text = self.languageDic?["text_input"] as? String
            self.phoneNumTextField.placeholder = self.languageDic?["text_username"] as? String
            self.nextBtn.setTitle(self.languageDic?["text_next"] as? String, for: .normal)
            self.backBtn.setAttributedTitle(Helpers.addDownLine((self.languageDic?["text_backtologin"] as? String)!,font:self.backBtn.titleLabel!.font,color: UIColor.white), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc:VerifyViewController = segue.destination as! VerifyViewController
        vc.phoneNum = (sender as! NSDictionary)["phone"] as? String
        vc.languageDic = self.languageDic
    }
    
    func requestUserName() -> Void {
        if self.phoneNumTextField.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入用户名")
            return
        }
        SVProgressHUD.show()
        NetworkModel.init(with: ["forgotten_nickname":self.phoneNumTextField.text ?? ""], url: "index.php?route=common/login/checkNickname", requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic = request.responseObject as! NSDictionary
            SVProgressHUD.dismiss()
            let error = dic["error"] as? NSObject
            if error == nil{
                if (dic["success"] as! NSNumber).intValue == 1{
                    self.performSegue(withIdentifier: "verifyPush", sender: dic)
                }else{
                    SVProgressHUD.showError(withStatus: dic["error"] as! String)
                }
            }else{
                SVProgressHUD.showError(withStatus: dic["error"] as! String)
            }
            
        }, failure: { (request) in
            SVProgressHUD.dismiss()
        })
    }
    
}
