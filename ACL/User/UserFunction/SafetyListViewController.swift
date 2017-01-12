//
//  SafetyListViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class SafetyListViewController: UITableViewController {
    
    
    @IBOutlet weak var updatePhoneBtn: UIButton!
    @IBOutlet weak var updatePwdBtn: UIButton!
    @IBOutlet weak var updateDealPwdBtn: UIButton!
    @IBOutlet weak var updateCardBtn: UIButton!
    @IBOutlet weak var updateRealNameBtn: UIButton!
    @IBOutlet weak var updateEmailBtn: UIButton!
    @IBOutlet weak var updateExtendCardBtn: UIButton!
    @IBOutlet weak var phoneTitle:UILabel!
    @IBOutlet weak var loginPwdTitle:UILabel!
    @IBOutlet weak var dealPwdTitle:UILabel!
    @IBOutlet weak var cardNoTitle:UILabel!
    @IBOutlet weak var realNameTitle:UILabel!
    @IBOutlet weak var emailTitle:UILabel!
    @IBOutlet weak var extendCardNoTitle:UILabel!
    @IBOutlet weak var phone:UILabel!
    @IBOutlet weak var loginPwd:UILabel!
    @IBOutlet weak var dealPwd:UILabel!
    @IBOutlet weak var cardNo:UILabel!
    @IBOutlet weak var realName:UILabel!
    @IBOutlet weak var email:UILabel!
    @IBOutlet weak var extendCardNo:UILabel!
    var dataSource:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.dataSource?["text_security_title"] as? String
        
        self.updatePhoneBtn.layer.cornerRadius = 4
        self.updatePwdBtn.layer.cornerRadius = 4
        self.updateDealPwdBtn.layer.cornerRadius = 4
        self.updateCardBtn.layer.cornerRadius = 4
        self.updateRealNameBtn.layer.cornerRadius = 4
        self.updateEmailBtn.layer.cornerRadius = 4
        self.updateExtendCardBtn.layer.cornerRadius = 4
        
        self.phoneTitle.text = self.dataSource?["text_security_phone"] as? String
        self.loginPwdTitle.text = self.dataSource?["text_security_setloginpsw"] as? String
        self.dealPwdTitle.text = self.dataSource?["text_security_settradepsw"] as? String
        self.cardNoTitle.text = self.dataSource?["text_security_setnewid"] as? String
        self.realNameTitle.text = self.dataSource?["text_security_settruename"] as? String
        self.emailTitle.text = self.dataSource?["text_security_setemail"] as? String
        self.extendCardNoTitle.text = self.dataSource?["text_security_newowner"] as? String
        
        self.phone.text = self.dataSource?["phone"] as? String
        self.loginPwd.text = self.dataSource?["text_security_set"] as? String
        self.dealPwd.text = self.dataSource?["security_tradepsw_set"] as? String
        self.cardNo.text = self.dataSource?["id_card_num_set"] as? String
        self.realName.text = self.dataSource?["id_card_name_set"] as? String
        self.email.text = self.dataSource?["email_set"] as? String
        self.extendCardNo.text = self.dataSource?["inherit_num_set"] as? String
        
        self.updatePhoneBtn.setTitle(self.dataSource?["text_security_change"] as? String, for: .normal)
        self.updatePwdBtn.setTitle(self.dataSource?["text_security_change"] as? String, for: .normal)
        self.updateDealPwdBtn.setTitle(self.dataSource?["text_security_change"] as? String, for: .normal)
        self.updateCardBtn.setTitle(self.dataSource?["text_security_change"] as? String, for: .normal)
        self.updateRealNameBtn.setTitle(self.dataSource?["text_security_change"] as? String, for: .normal)
        self.updateEmailBtn.setTitle(self.dataSource?["text_security_change"] as? String, for: .normal)
        self.updateExtendCardBtn.setTitle(self.dataSource?["text_security_change"] as? String, for: .normal)
        
    }
    
    @IBAction func updatePhoneBtnDidClick(_ sender: Any) {
        self.performSegue(withIdentifier: "updatePush", sender: sender)
    }
    
    @IBAction func updatePwdBtnDidClick(_ sender: Any) {
        self.performSegue(withIdentifier: "updatePush", sender: sender)
    }
    
    @IBAction func updateDealPwdBtnDidClick(_ sender: Any) {
        self.performSegue(withIdentifier: "updatePush", sender: sender)
    }
    
    @IBAction func updateCardBtnDidClick(_ sender: Any) {
        self.performSegue(withIdentifier: "updatePush", sender: sender)
    }
    
    @IBAction func updateRealNameBtnDidClick(_ sender: Any) {
        self.performSegue(withIdentifier: "updatePush", sender: sender)
    }
    
    @IBAction func updateEmailBtnDidClick(_ sender: Any) {
        self.performSegue(withIdentifier: "updatePush", sender: sender)
    }
    
    @IBAction func updateExtendCardBtnDidClick(_ sender: Any) {
        self.performSegue(withIdentifier: "updatePush", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updatePush" {
            let safety:SafetyUpdateViewController = segue.destination as! SafetyUpdateViewController
            safety.tag = (sender as! UIButton).tag
            safety.dataSource = self.dataSource
            switch (sender as! UIButton).tag {
            case 1:
                safety.title = self.dataSource?["text_security_phone"] as? String
                safety.type = .PhoneNum
                safety.completeUpdate = {(_ indexPath:IndexPath, updateInfo:String) -> Void in
                    
                }
                break
            case 2:
                safety.title = self.dataSource?["text_security_setloginpsw"] as? String
                safety.type = SafetyUpdateType.LoginPwd
                break
            case 3:
                safety.title = self.dataSource?["text_security_settradepsw"] as? String
                safety.type = SafetyUpdateType.DealPwd
                break
            case 4:
                safety.title = self.dataSource?["text_security_setnewid"] as? String
                safety.type = SafetyUpdateType.Card
                break
            case 5:
                safety.title = self.dataSource?["text_security_settruename"] as? String
                safety.type = SafetyUpdateType.RealName
                break
            case 6:
                safety.title = self.dataSource?["text_security_setemail"] as? String
                safety.type = SafetyUpdateType.Email
                break
            case 7:
                safety.title = self.dataSource?["text_security_newowner"] as? String
                safety.type = SafetyUpdateType.ExtendCard
                break
            default:
                break
            }
        }
    }
    
}
