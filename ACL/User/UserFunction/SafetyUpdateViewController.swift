//
//  SafetyUpdateViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

enum SafetyUpdateType {
    case PhoneNum
    case LoginPwd
    case DealPwd
    case Card
    case RealName
    case Email
    case ExtendCard
}

class SafetyUpdateViewController: UITableViewController {
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var sureBtn: UIButton!
    var textField: UITextField?
    var sureTextField: UITextField?
    var type:SafetyUpdateType?
    var tag:Int?
    var completeUpdate:((IndexPath,String) -> Void)?
    var dataSource:NSDictionary?
    
    @IBAction func sureBtnDidClick(_ sender: Any) {
        self.requestUpdateInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sureBtn.layer.cornerRadius = 6
        self.sureBtn.setTitle(self.dataSource?["text_security_submit"] as? String, for: .normal)
        switch self.type! {
        case .PhoneNum:
            self.phoneLabel.text = self.dataSource?["text_security_setphone"] as? String
            break
        case .LoginPwd:
            self.phoneLabel.text = self.dataSource?["text_security_setloginpsw"] as? String
            break
        case .DealPwd:
            self.phoneLabel.text = self.dataSource?["text_security_settradepsw"] as? String
            break
        case .Card:
            self.phoneLabel.text = self.dataSource?["text_security_setnewid"] as? String
            break
        case .RealName:
            self.phoneLabel.text = self.dataSource?["text_security_settruename"] as? String
            break
        case .Email:
            self.phoneLabel.text = self.dataSource?["text_security_setemail"] as? String
            break
        case .ExtendCard:
            self.phoneLabel.text = self.dataSource?["text_security_setnewowner"] as? String
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type == .PhoneNum {
            return 1
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        let textField = cell.viewWithTag(2) as! UITextField
        textField.keyboardType = .default
        textField.isSecureTextEntry = false
        switch self.type! {
        case .PhoneNum:
            label.text = self.dataSource?["text_security_newphone"] as? String
            self.textField = textField
            textField.keyboardType = .numberPad
            break
        case .LoginPwd:
            if indexPath.row == 0 {
                self.textField = textField
                label.text = self.dataSource?["text_security_inputnewpsw"] as? String
                textField.isSecureTextEntry = true
            }else{
                self.sureTextField = textField
                label.text = self.dataSource?["text_security_renewpsw"] as? String
                textField.isSecureTextEntry = true
            }
            break
        case .DealPwd:
            if indexPath.row == 0 {
                self.textField = textField
                label.text = self.dataSource?["text_security_inputnewpsw"] as? String
                textField.isSecureTextEntry = true
            }else{
                self.sureTextField = textField
                label.text = self.dataSource?["text_security_renewpsw"] as? String
                textField.isSecureTextEntry = true
            }
            break
        case .Card:
            if indexPath.row == 0 {
                self.textField = textField
                label.text = self.dataSource?["text_security_oldid"] as? String
            }else{
                self.sureTextField = textField
                label.text = self.dataSource?["text_security_newid"] as? String
            }
            break
        case .RealName:
            if indexPath.row == 0 {
                self.textField = textField
                label.text = self.dataSource?["text_security_oldname"] as? String
            }else{
                self.sureTextField = textField
                label.text = self.dataSource?["text_security_newname"] as? String
            }
            break
        case .Email:
            if indexPath.row == 0 {
                self.textField = textField
                label.text = self.dataSource?["text_security_oldemail"] as? String
            }else{
                self.sureTextField = textField
                label.text = self.dataSource?["text_security_newemail"] as? String
            }
            break
        case .ExtendCard:
            if indexPath.row == 0 {
                self.textField = textField
                label.text = self.dataSource?["text_security_oldownerid"] as? String
            }else{
                self.sureTextField = textField
                label.text = self.dataSource?["text_security_newownerid"] as? String
            }
            break
        }
        return cell
    }
    
    func requestUpdateInfo() {
        SVProgressHUD.show()
        var url = ""
        var dic = [String:String]()
        switch self.type! {
        case .PhoneNum:
            url = "index.php?route=account/security/validatePhoneForm&token="
            dic = ["new_phone":(self.textField?.text ?? "")]
            break
        case .LoginPwd:
            url = "index.php?route=account/security/validatePasswordForm&token="
            dic = ["password":(self.textField?.text ?? ""),"confirm":(self.sureTextField?.text ?? "")]
            break
        case .DealPwd:
            url = "index.php?route=account/security/validateAccountPasswordForm&token="
            dic = ["account_password":(self.textField?.text ?? ""),"account_confirm":(self.sureTextField?.text ?? "")]
            break
        case .Card:
            url = "index.php?route=account/security/validateIdCardForm&token="
            dic = ["id_card":(self.sureTextField?.text ?? "")]
            break
        case .RealName:
            url = "index.php?route=account/security/validateIdCardNameForm&token="
            dic = ["id_card_name":(self.sureTextField?.text ?? "")]
            break
        case .Email:
            url = "index.php?route=account/security/validateEmailForm&token="
            dic = ["email":(self.sureTextField?.text ?? "")]
            break
        case .ExtendCard:
            url = "index.php?route=account/security/validateInheritNumForm&token="
            dic = ["inherit_num":(self.sureTextField?.text ?? "")]
            break
        }
        url = "https://www.usacl.com/app/v1/" + url + (UserDefaults.standard.object(forKey: "token") as? String)!
        var body = ""
        for key in dic.keys {
            body = key + dic[key]!
        }
        let bodyData = body.data(using: .utf8)
        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = "POST"
        req.httpBody = bodyData
        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue(), completionHandler: {(_ response:URLResponse?, data:Data?, error:Error?) -> Void in
            if error == nil {
                do{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    DispatchQueue.main.async(execute: { 
                        if Int(dic["login"] as! String) == 1 {
                            if dic["success"] != nil {
                                let indexPath = IndexPath(row: self.tag!, section: 0)
                                if self.sureTextField != nil {
                                    self.completeUpdate!(indexPath,self.sureTextField?.text ?? "")
                                }else{
                                    self.completeUpdate!(indexPath,self.textField?.text ?? "")
                                }
                            }else{
                                switch self.type!{
                                case .PhoneNum:
                                    SVProgressHUD.showError(withStatus: dic["error_new_phone"] as! String)
                                    break
                                case.LoginPwd:
                                    if dic["error_confirm"] != nil {
                                        SVProgressHUD.showError(withStatus: dic["error_confirm"] as! String)
                                    }else if dic["error_password"] != nil{
                                        SVProgressHUD.showError(withStatus: dic["error_password"] as! String)
                                    }
                                    break
                                case.DealPwd:
                                    if dic["error_password"] != nil {
                                        SVProgressHUD.showError(withStatus: dic["error_password"] as! String)
                                    }else if dic["error_password"] != nil{
                                        SVProgressHUD.showError(withStatus: dic["error_confirm"] as! String)
                                    }
                                    break
                                case.Card:
                                    if dic["error_id_card"] != nil {
                                        SVProgressHUD.showError(withStatus: dic["error_id_card"] as! String)
                                    }
                                    break
                                case.RealName:
                                    if dic["error_id_card_name"] != nil {
                                        SVProgressHUD.showError(withStatus: dic["error_id_card_name"] as! String)
                                    }
                                    break
                                case.Email:
                                    if dic["error_email"] != nil {
                                        SVProgressHUD.showError(withStatus: dic["error_email"] as! String)
                                    }
                                    break
                                case.ExtendCard:
                                    if dic["error_inherit_num"] != nil {
                                        SVProgressHUD.showError(withStatus: dic["error_inherit_num"] as! String)
                                    }
                                    break
                                }
                            }
                        }else{
                            self.dismiss(animated: true, completion: nil)
                            SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
                        }

                    })
                }catch{
                
                }
            }else{
                SVProgressHUD.dismiss()
                print(error!)
            }
        })
        
        
        
        
        
        
        
//        NetworkModel.init(with: dic as NSDictionary?, url: url, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
//            SVProgressHUD.dismiss()
//            let dic:NSDictionary = request.responseObject as! NSDictionary
//            print(dic)
//            if Int(dic["login"] as! String) == 1 {
//                if dic["success"] != nil {
//                    let indexPath = IndexPath(row: self.tag!, section: 0)
//                    if self.sureTextField != nil {
//                        self.completeUpdate!(indexPath,self.sureTextField?.text ?? "")
//                    }else{
//                        self.completeUpdate!(indexPath,self.textField?.text ?? "")
//                    }
//                }else{
//                    switch self.type!{
//                    case .PhoneNum:
//                        SVProgressHUD.showError(withStatus: dic["error_new_phone"] as! String)
//                        break
//                    case.LoginPwd:
//                        if dic["error_confirm"] != nil {
//                            SVProgressHUD.showError(withStatus: dic["error_confirm"] as! String)
//                        }else if dic["error_password"] != nil{
//                            SVProgressHUD.showError(withStatus: dic["error_password"] as! String)
//                        }
//                        break
//                    case.DealPwd:
//                        if dic["error_password"] != nil {
//                            SVProgressHUD.showError(withStatus: dic["error_password"] as! String)
//                        }else if dic["error_password"] != nil{
//                            SVProgressHUD.showError(withStatus: dic["error_confirm"] as! String)
//                        }
//                        break
//                    case.Card:
//                        if dic["error_id_card"] != nil {
//                            SVProgressHUD.showError(withStatus: dic["error_id_card"] as! String)
//                        }
//                        break
//                    case.RealName:
//                        if dic["error_id_card_name"] != nil {
//                            SVProgressHUD.showError(withStatus: dic["error_id_card_name"] as! String)
//                        }
//                        break
//                    case.Email:
//                        if dic["error_email"] != nil {
//                            SVProgressHUD.showError(withStatus: dic["error_email"] as! String)
//                        }
//                        break
//                    case.ExtendCard:
//                        if dic["error_inherit_num"] != nil {
//                            SVProgressHUD.showError(withStatus: dic["error_inherit_num"] as! String)
//                        }
//                        break
//                    }
//                }
//            }else{
//                self.dismiss(animated: true, completion: nil)
//                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
//            }
//        }, failure: { (request) in
//            
//        })
    }
    
}
