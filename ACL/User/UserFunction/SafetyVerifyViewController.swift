//
//  SafetyVerifyViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class SafetyVerifyViewController: UITableViewController {
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var sureBtn: UIButton!
    var verifyTextField:UITextField? = nil
    var verifyBtn:UIButton? = nil
    var dataSource:NSDictionary?
    var count = 0
    var accountVerify:Bool = false
    
    
    @IBAction func sureBtnDidClick(_ sender: Any) {
//        self.performSegue(withIdentifier: "safetyListPush", sender: nil)
        self.requestSendCode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sureBtn.layer.cornerRadius = 6
        self.title = "安全设置"
        self.requestSafe()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        verifyTextField = cell.viewWithTag(1) as? UITextField
        verifyBtn = cell.viewWithTag(2) as? UIButton
        verifyTextField?.addTarget(self, action: #selector(editDidChange(_:)), for: .editingChanged)
        verifyBtn?.addTarget(self, action: #selector(verifyBtnDidClick(_:)), for: .touchUpInside)
        verifyTextField?.placeholder = self.dataSource?["text_security_phonecode"] as? String
        verifyBtn?.setTitle(self.dataSource?["text_security_sendphonecode"] as? String, for: .normal)
        return cell
    }
    
    func editDidChange(_ sender:UITextField) -> Void {
        if (sender.text?.characters.count)! > 6 {
            sender.text = sender.text?.substring(to: (sender.text?.index((sender.text?.startIndex)!, offsetBy: 6))!)
        }
    }
    
    func verifyBtnDidClick(_ sender:UIButton) -> Void {
        self.requestGetVerifyCode()
    }
    
    func cutDown(_ time:Timer) -> Void {
        count = count - 1
        if count < 0 {
            verifyBtn?.isUserInteractionEnabled = true
            verifyBtn?.setTitleColor(UIColor.colorWithHexString(hex: "F27B81"), for: .normal)
            verifyBtn?.setTitle((self.dataSource?["text_security_sendphonecode"] as? String)!, for: .normal)
            time.invalidate()
        }else{
            verifyBtn?.setTitle(String(count) + (self.dataSource?["entry_security_code_time"] as? String)!, for: .normal)
        }
    }
    
    func requestSafe() {
        SVProgressHUD.show()
        NetworkModel.init(with: [:], url: "index.php?route=account/security&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            SVProgressHUD.dismiss()
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                self.dataSource = dic
                self.phoneLabel.text = self.dataSource?["text_security_page_change"] as? String
                self.sureBtn.setTitle(self.dataSource?["text_security_submit"] as? String, for: .normal)
                self.title = self.dataSource?["text_security_title"] as? String
                self.tableView.reloadData()
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure: { (request) in
            print(request.error!)
            SVProgressHUD.dismiss()
        })
    }
    
    func requestGetVerifyCode() -> Void {
        SVProgressHUD.show()
        NetworkModel.init(with: [:], url: "index.php?route=account/security/enterSecurityCode&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            SVProgressHUD.dismiss()
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                if dic["error"] != nil {
                    SVProgressHUD.showError(withStatus: dic["error"] as! String)
                }else if dic["success"] != nil{
                    print("发送成功")
                    self.count = 60
                    self.verifyBtn?.isUserInteractionEnabled = false
                    self.verifyBtn?.setTitle(String(self.count) + (self.dataSource?["entry_security_code_time"] as? String)!, for: .normal)
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(SafetyVerifyViewController.cutDown(_:)), userInfo: nil, repeats: true)
                }
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure: { (request) in
            print(request.error!)
            SVProgressHUD.dismiss()
        })
    }
    
    func requestSendCode() {
        SVProgressHUD.show()
        NetworkModel.init(with: ["verification":(self.verifyTextField?.text)!], url: "index.php?route=account/security&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            SVProgressHUD.dismiss()
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                if (dic["correct_verification"] as! NSNumber).intValue == 1 {
                    if self.accountVerify {
                        self.performSegue(withIdentifier: "accountPush", sender: nil)
                    }else{
                        self.performSegue(withIdentifier: "safetyListPush", sender: nil)
                    }
                }else{
                    SVProgressHUD.showError(withStatus: dic["error_verification"] as! String)
                }
            }else{
                self.dismiss(animated: true, completion: nil)
//                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
            
        }, failure: { (request) in
            SVProgressHUD.dismiss()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "safetyListPush" {
            let vc = segue.destination as! SafetyListViewController
            vc.dataSource = self.dataSource
        }else if segue.identifier == "accountPush" {
            
        }
    }
    
}
