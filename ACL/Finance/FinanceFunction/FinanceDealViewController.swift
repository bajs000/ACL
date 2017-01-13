//
//  FinanceDealViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/19.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

enum usDealType:Int {
    case cashToUs = 3
    case usToCash = 4
    case usToShop = 5
    case shopToUs = 6
}

class FinanceDealViewController: UITableViewController {
    
    var dataSource:NSDictionary?
    var resultDic:NSDictionary?
    var showError = false
    var type:FinanceType?
    var usType:usDealType?
    var indexPath:IndexPath?
    var needSection:Bool = false
    var textFieldDic = [String:UITextField]()
    var amountTextField: UITextField?
    var discountText: UITextField?
    var receiveText: UITextField?
    var currentAccount: String = ""
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var commitBtn: UIButton!
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        showError = true
        var url = ""
        var dic = [String:String]()
        if self.type! == .cash {
            if self.needSection {
                url = "index.php?route=finance/coin/validateSellCoin&token="
                dic["sell_amount"] = textFieldDic["1"]?.text
                dic["sell_account_password"] = textFieldDic["4"]?.text
            }else{
                url = "index.php?route=finance/coin/validateTransfer&token="
                dic["amount"] = textFieldDic["2"]?.text
                dic["account_password"] = textFieldDic["3"]?.text
            }
        }else if self.type! == .usScore{
            if self.usType! == .cashToUs {
                url = "index.php?route=finance/reward/validateTransfer&token="
                dic["amount"] = textFieldDic["2"]?.text
                dic["account_password"] = textFieldDic["3"]?.text
            }else if self.usType! == .usToCash {
                url = "index.php?route=finance/reward/validateReturnCoin&token="
                dic["return_amount"] = textFieldDic["2"]?.text
                dic["return_account_password"] = textFieldDic["3"]?.text
            }else if self.usType! == .usToShop {
                url = "index.php?route=finance/reward/validateStoreCreditTransfer&token="
                dic["credit_amount"] = textFieldDic["2"]?.text
                dic["return_reward_account_password"] = textFieldDic["3"]?.text
            }else if self.usType! == .shopToUs {
                url = "index.php?route=finance/reward/validateReturnReward&token="
                dic["return_reward"] = textFieldDic["2"]?.text
                dic["return_reward_account_password"] = textFieldDic["3"]?.text
            }
        }else if self.type! == .regist {
            url = "index.php?route=finance/activation&token="
            dic["nickname"] = textFieldDic["1"]?.text
            dic["amount"] = textFieldDic["2"]?.text
            dic["account_password"] = textFieldDic["3"]?.text
        }
        url = url + (UserDefaults.standard.object(forKey: "token") as? String)!
        SVProgressHUD.show()
        NetworkModel.init(with: dic as NSDictionary?, url: url, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            SVProgressHUD.dismiss()
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                self.resultDic = dic
                if self.resultDic != nil {
                    self.tableView.reloadData()
                    if self.resultDic?["success"] != nil && (self.resultDic?["success"] as! String).characters.count > 0{
                        SVProgressHUD.showSuccess(withStatus: (self.resultDic?["success"] as! String))
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }, failure: { (request) in
            
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commitBtn.layer.cornerRadius = 6
        if self.type == .cash || self.type == .cashDeal {
            if needSection {
                self.title = self.dataSource?["text_cash_sell"] as? String
            }else{
                self.title = self.dataSource?["text_cash_transfer"] as? String
            }
            self.commitBtn.setTitle(self.dataSource?["text_cash_submit"] as? String, for: .normal)
        }else if self.type == .regist{
            self.title = self.dataSource?["text_activation_transfer"] as? String
            self.commitBtn.setTitle(self.dataSource?["text_activation_submit"] as? String, for: .normal)
        }else if self.type == .usScore{
            if self.usType! == .cashToUs {
                self.title = self.dataSource?["text_reward_transfer"] as? String
                self.commitBtn.setTitle(self.dataSource?["text_reward_submit"] as? String, for: .normal)
            }else if self.usType! == .usToCash {
                self.title = self.dataSource?["text_return_coin"] as? String
                self.commitBtn.setTitle(self.dataSource?["text_reward_submit"] as? String, for: .normal)
            }else if self.usType! == .usToShop {
                self.title = self.dataSource?["text_reward_storecredit"] as? String
                self.commitBtn.setTitle(self.dataSource?["text_reward_submit"] as? String, for: .normal)
            }else if self.usType! == .shopToUs {
                self.title = self.dataSource?["text_return_reward"] as? String
                self.commitBtn.setTitle(self.dataSource?["text_reward_submit"] as? String, for: .normal)
            }
        }
    }
    
    public class func getInstance() -> FinanceDealViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "financeDeal") as! FinanceDealViewController
        return vc
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if needSection {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 48
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return self.headerView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.type! {
        case .regist:
            return 4
        case .cash:
            if needSection {
                return 5
            }
            return 4
        case .cashDeal:
            if needSection {
                return 5
            }
            return 4
        case .usScore:
            if self.usType! == .cashToUs {
                return 4
            }else if self.usType! == .usToCash {
                return 4
            }else if self.usType! == .usToShop {
                return 3
            }else if self.usType! == .shopToUs {
                return 4
            }
            return 0
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label = (cell.viewWithTag(1) as! UILabel)
        let textField = cell.viewWithTag(2) as! UITextField
        textField.isEnabled = true
        textField.isSecureTextEntry = false
        textField.keyboardType = .default
        self.textFieldDic[String(indexPath.row)] = textField
        
        
        textField.layer.borderWidth = 0
        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
        textField.placeholder = ""
        
        switch self.type! {
        case .regist:
            switch indexPath.row {
            case 0:
                label.text = self.dataSource?["text_activation_hold"] as? String
                textField.text = self.dataSource?["active_coin"] as? String
                textField.isEnabled = false
                break
            case 1:
                label.text = self.dataSource?["text_activation_target"] as? String
                if self.resultDic?["error_name"] != nil && (self.resultDic?["error_name"] as! String).characters.count > 0 && self.showError {
                    textField.layer.cornerRadius = 4
                    textField.layer.borderColor = UIColor.red.cgColor
                    textField.layer.borderWidth = 1
                    (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                    textField.placeholder = self.resultDic?["error_name"] as? String
                    textField.text = nil
                }
                break
            case 2:
                label.text = self.dataSource?["text_activation_amount"] as? String
                textField.keyboardType = .numberPad
                if self.resultDic?["error_amount"] != nil && (self.resultDic?["error_amount"] as! String).characters.count > 0 && self.showError {
                    textField.layer.cornerRadius = 4
                    textField.layer.borderColor = UIColor.red.cgColor
                    textField.layer.borderWidth = 1
                    (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                    textField.placeholder = self.resultDic?["error_amount"] as? String
                    textField.text = nil
                }
                break
            case 3:
                label.text = self.dataSource?["text_activation_psw"] as? String
                textField.isSecureTextEntry = true
                if self.resultDic?["error_password"] != nil && (self.resultDic?["error_password"] as! String).characters.count > 0 && self.showError {
                    textField.layer.cornerRadius = 4
                    textField.layer.borderColor = UIColor.red.cgColor
                    textField.layer.borderWidth = 1
                    (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                    textField.placeholder = self.resultDic?["error_password"] as? String
                    textField.text = nil
                }
                break
            default:
                break
            }
            break
        case .cash, .cashDeal:
            textField.removeTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            if self.needSection{
                textField.text = nil
                if indexPath.section == 0 {
                    switch indexPath.row {
                    case 0:
                        label.text = self.dataSource?["text_cash_cashcoin"] as? String
                        textField.text = self.dataSource?["active_coin"] as? String
                        textField.isEnabled = false
                        break
                    case 1:
                        label.text = self.dataSource?["text_cash_sellamount"] as? String
                        textField.keyboardType = .numberPad
                        if self.resultDic?["error_amount"] != nil && (self.resultDic?["error_amount"] as! String).characters.count > 0 && self.showError {
                            textField.layer.cornerRadius = 4
                            textField.layer.borderColor = UIColor.red.cgColor
                            textField.layer.borderWidth = 1
                            (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                            textField.placeholder = self.resultDic?["error_amount"] as? String
                            textField.text = nil
                        }
                        textField.text = self.currentAccount
                        self.amountTextField = textField
                        self.amountTextField?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
                        break
                    case 2:
                        label.text = self.dataSource?["text_cash_fee"] as? String
                        textField.keyboardType = .numberPad
                        textField.isEnabled = false
                        self.discountText = textField
                        if self.currentAccount.characters.count > 0 {
                            textField.text = "$" + String(Float(self.currentAccount)! * 0.1)
                        }else{
                            textField.text = "$0"
                        }
                        break
                    case 3:
                        label.text = self.dataSource?["text_cash_realincome"] as? String
                        textField.isEnabled = false
                        self.receiveText = textField
                        if self.currentAccount.characters.count > 0 {
                            textField.text = "$" + String(Float(self.currentAccount)! * 0.9)
                        }else{
                            textField.text = "$0"
                        }
                        break
                    case 4:
                        label.text = self.dataSource?["text_cash_psw"] as? String
                        textField.isSecureTextEntry = true
                        if self.resultDic?["error_password"] != nil && (self.resultDic?["error_password"] as! String).characters.count > 0 && self.showError {
                            textField.layer.cornerRadius = 4
                            textField.layer.borderColor = UIColor.red.cgColor
                            textField.layer.borderWidth = 1
                            (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                            textField.placeholder = self.resultDic?["error_password"] as? String
                            textField.text = nil
                        }
                        break
                    default:
                        break
                    }
                }else{
                    textField.isEnabled = false
                    switch indexPath.row {
                    case 0:
                        label.text = self.dataSource?["text_cash_cardnumber"] as? String
                        textField.text = self.dataSource?["card_number"] as? String
                        break
                    case 1:
                        label.text = self.dataSource?["text_cash_bank"] as? String
                        textField.text = self.dataSource?["bank"] as? String
                        break
                    case 2:
                        label.text = self.dataSource?["text_cash_cardholder"] as? String
                        textField.text = self.dataSource?["card_holder"] as? String
                        break
                    case 3:
                        label.text = self.dataSource?["text_cash_alipay"] as? String
                        textField.text = self.dataSource?["alipay"] as? String
                        break
                    case 4:
                        label.text = self.dataSource?["text_cash_bitcoin"] as? String
                        textField.text = self.dataSource?["bitcoin"] as? String
                        break
                    default:
                        break
                    }
                }
            }else{
                switch indexPath.row {
                case 0:
                    label.text = self.dataSource?["text_cash_cashcoin"] as? String
                    textField.text = self.dataSource?["active_coin"] as? String
                    textField.isEnabled = false
                    break
                case 1:
                    label.text = self.dataSource?["text_cash_activationcoin"] as? String
                    textField.text = self.dataSource?["reamin_activation_coin"] as? String
                    textField.isEnabled = false
                    break
                case 2:
                    label.text = self.dataSource?["text_cash_transferamount"] as? String
                    textField.keyboardType = .numberPad
                    if self.resultDic?["error_amount"] != nil && (self.resultDic?["error_amount"] as! String).characters.count > 0 && self.showError {
                        textField.layer.cornerRadius = 4
                        textField.layer.borderColor = UIColor.red.cgColor
                        textField.layer.borderWidth = 1
                        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                        textField.placeholder = self.resultDic?["error_amount"] as? String
                        textField.text = nil
                    }
                    break
                case 3:
                    label.text = self.dataSource?["text_cash_psw"] as? String
                    textField.isSecureTextEntry = true
                    if self.resultDic?["error_password"] != nil && (self.resultDic?["error_password"] as! String).characters.count > 0 && self.showError {
                        textField.layer.cornerRadius = 4
                        textField.layer.borderColor = UIColor.red.cgColor
                        textField.layer.borderWidth = 1
                        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                        textField.placeholder = self.resultDic?["error_password"] as? String
                        textField.text = nil
                    }
                    break
                default:
                    break
                }
            }
            break
        case .usScore:
            if self.usType! == .cashToUs {
                switch indexPath.row {
                case 0:
                    label.text = self.dataSource?["text_cash_cashcoin"] as? String
                    textField.text = self.dataSource?["active_coin"] as? String
                    textField.isEnabled = false
                    break
                case 1:
                    label.text = self.dataSource?["text_reward_hold"] as? String
                    textField.text = self.dataSource?["rewards_total"] as? String
                    textField.isEnabled = false
                    break
                case 2:
                    label.text = self.dataSource?["text_cash_transferamount"] as? String
                    textField.placeholder = self.dataSource?["text_cash_trasferrule"] as? String
                    textField.keyboardType = .numberPad
                    if self.resultDic?["error_amount"] != nil && (self.resultDic?["error_amount"] as! String).characters.count > 0 && self.showError {
                        textField.layer.cornerRadius = 4
                        textField.layer.borderColor = UIColor.red.cgColor
                        textField.layer.borderWidth = 1
                        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                        textField.placeholder = self.resultDic?["error_amount"] as? String
                        textField.text = nil
                    }
                    break
                case 3:
                    label.text = self.dataSource?["text_cash_psw"] as? String
                    textField.isSecureTextEntry = true
                    if self.resultDic?["error_password"] != nil && (self.resultDic?["error_password"] as! String).characters.count > 0 && self.showError {
                        textField.layer.cornerRadius = 4
                        textField.layer.borderColor = UIColor.red.cgColor
                        textField.layer.borderWidth = 1
                        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                        textField.placeholder = self.resultDic?["error_password"] as? String
                        textField.text = nil
                    }
                    break
                default:
                    break
                }
                break
            }else if self.usType! == .usToCash {
                switch indexPath.row {
                case 0:
                    label.text = self.dataSource?["text_cash_cashcoin"] as? String
                    textField.text = self.dataSource?["active_coin"] as? String
                    textField.isEnabled = false
                    break
                case 1:
                    label.text = self.dataSource?["text_reward_hold"] as? String
                    textField.text = self.dataSource?["rewards_total"] as? String
                    textField.isEnabled = false
                    break
                case 2:
                    label.text = self.dataSource?["text_cash_transferamount"] as? String
                    textField.placeholder = self.dataSource?["text_cash_trasferrule"] as? String
                    textField.keyboardType = .numberPad
                    if self.resultDic?["error_amount"] != nil && (self.resultDic?["error_amount"] as! String).characters.count > 0 && self.showError {
                        textField.layer.cornerRadius = 4
                        textField.layer.borderColor = UIColor.red.cgColor
                        textField.layer.borderWidth = 1
                        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                        textField.placeholder = self.resultDic?["error_amount"] as? String
                        textField.text = nil
                    }
                    break
                case 3:
                    label.text = self.dataSource?["text_cash_psw"] as? String
                    textField.isSecureTextEntry = true
                    if self.resultDic?["error_password"] != nil && (self.resultDic?["error_password"] as! String).characters.count > 0 && self.showError {
                        textField.layer.cornerRadius = 4
                        textField.layer.borderColor = UIColor.red.cgColor
                        textField.layer.borderWidth = 1
                        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                        textField.placeholder = self.resultDic?["error_password"] as? String
                        textField.text = nil
                    }
                    break
                default:
                    break
                }
                break
            }else if self.usType! == .usToShop {
                switch indexPath.row {
                case 0:
                    label.text = self.dataSource?["text_reward_hold"] as? String
                    textField.text = self.dataSource?["rewards_total"] as? String
                    textField.isEnabled = false
                    break
                case 1:
                    label.text = self.dataSource?["text_cash_transferamount"] as? String
                    textField.placeholder = self.dataSource?["text_cash_trasferrule"] as? String
                    textField.keyboardType = .numberPad
                    if self.resultDic?["error_amount"] != nil && (self.resultDic?["error_amount"] as! String).characters.count > 0 && self.showError {
                        textField.layer.cornerRadius = 4
                        textField.layer.borderColor = UIColor.red.cgColor
                        textField.layer.borderWidth = 1
                        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                        textField.placeholder = self.resultDic?["error_amount"] as? String
                        textField.text = nil
                    }
                    break
                case 2:
                    label.text = self.dataSource?["text_cash_psw"] as? String
                    textField.isSecureTextEntry = true
                    if self.resultDic?["error_password"] != nil && (self.resultDic?["error_password"] as! String).characters.count > 0 && self.showError {
                        textField.layer.cornerRadius = 4
                        textField.layer.borderColor = UIColor.red.cgColor
                        textField.layer.borderWidth = 1
                        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                        textField.placeholder = self.resultDic?["error_password"] as? String
                        textField.text = nil
                    }
                    break
                default:
                    break
                }
                break
            }else if self.usType! == .shopToUs {
                switch indexPath.row {
                case 0:
                    label.text = self.dataSource?["text_store_credit"] as? String
                    textField.text = self.dataSource?["total_store_credit"] as? String
                    textField.isEnabled = false
                    break
                case 1:
                    label.text = self.dataSource?["text_reward_hold"] as? String
                    textField.text = self.dataSource?["rewards_total"] as? String
                    textField.isEnabled = false
                    break
                case 2:
                    label.text = self.dataSource?["text_cash_transferamount"] as? String
                    textField.placeholder = self.dataSource?["text_cash_trasferrule"] as? String
                    textField.keyboardType = .numberPad
                    if self.resultDic?["error_amount"] != nil && (self.resultDic?["error_amount"] as! String).characters.count > 0 && self.showError {
                        textField.layer.cornerRadius = 4
                        textField.layer.borderColor = UIColor.red.cgColor
                        textField.layer.borderWidth = 1
                        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                        textField.placeholder = self.resultDic?["error_amount"] as? String
                        textField.text = nil
                    }
                    break
                case 3:
                    label.text = self.dataSource?["text_cash_psw"] as? String
                    textField.isSecureTextEntry = true
                    if self.resultDic?["error_password"] != nil && (self.resultDic?["error_password"] as! String).characters.count > 0 && self.showError {
                        textField.layer.cornerRadius = 4
                        textField.layer.borderColor = UIColor.red.cgColor
                        textField.layer.borderWidth = 1
                        (textField as! UITextFieldFactory).placeholderColor = UIColor.red
                        textField.placeholder = self.resultDic?["error_password"] as? String
                        textField.text = nil
                    }
                    break
                default:
                    break
                }
                break
            }
        default:
            break
        }
        return cell
    }
    
    func textDidChange(_ sender: UITextField){
        currentAccount = sender.text!
        
        if self.currentAccount.characters.count > 0 {
            self.discountText?.text = "$" + String(Float(currentAccount)! * 0.1)
            self.receiveText?.text = "$" + String(Float(currentAccount)! * 0.9)
        }else{
            self.discountText?.text = "$0"
            self.receiveText?.text = "$0"
        }
    }
    
}
