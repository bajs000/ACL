//
//  AccountViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/1.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class AccountViewController: UITableViewController {
    
    @IBOutlet weak var saveBtn: UIButton!
    var accountArr:NSArray? = []
    var dataSource:NSDictionary?
    var showError = false
    
    var nameText:UITextField?
    var bankText:UITextField?
    var cardText:UITextField?
    var alipayText:UITextField?
    var weixinText:UITextField?
    var bitcionText:UITextField?
    
    @IBAction func saveBtnDidClick(_ sender: Any) {
        var dic = [String:String]()
        if (nameText?.text?.characters.count)! > 0 {
            dic["name"] = nameText?.text
        }
        if (bankText?.text?.characters.count)! > 0 {
            dic["bank"] = bankText?.text
        }
        if (cardText?.text?.characters.count)! > 0 {
            dic["card"] = cardText?.text
        }
        if (alipayText?.text?.characters.count)! > 0 {
            dic["alipay"] = alipayText?.text
        }
        if (weixinText?.text?.characters.count)! > 0 {
            dic["wechat"] = weixinText?.text
        }
        if (bitcionText?.text?.characters.count)! > 0 {
            dic["bitcoin"] = bitcionText?.text
        }
        showError = true
        self.requestAccount(dic as NSDictionary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveBtn.layer.cornerRadius = 6
        self.requestAccount([:])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (accountArr?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = (accountArr?[indexPath.row] as! NSDictionary)["title"] as? String
        (cell.viewWithTag(2) as! UITextField).text = (accountArr?[indexPath.row] as! NSDictionary)["placeholder"] as? String
        (cell.viewWithTag(2) as! UITextField).keyboardType = .default
        (cell.viewWithTag(2) as! UITextField).layer.borderWidth = 0
        (cell.viewWithTag(2) as! UITextFieldFactory).placeholderColor = UIColor.clear
        (cell.viewWithTag(2) as! UITextFieldFactory).placeholder = ""
        switch indexPath.row {
        case 0:
            nameText = (cell.viewWithTag(2) as! UITextField)
            if self.dataSource?["error_name"] != nil && (self.dataSource?["error_name"] as! String).characters.count > 0 && self.showError{
                (cell.viewWithTag(2) as! UITextField).layer.cornerRadius = 4
                (cell.viewWithTag(2) as! UITextField).layer.borderColor = UIColor.red.cgColor
                (cell.viewWithTag(2) as! UITextField).layer.borderWidth = 1
                (cell.viewWithTag(2) as! UITextFieldFactory).placeholderColor = UIColor.red
                (cell.viewWithTag(2) as! UITextFieldFactory).placeholder = self.dataSource?["error_name"] as? String
                (cell.viewWithTag(2) as! UITextField).text = ""
            }
            break
        case 1:
            bankText = (cell.viewWithTag(2) as! UITextField)
            if self.dataSource?["error_bank"] != nil && (self.dataSource?["error_bank"] as! String).characters.count > 0 && self.showError{
                (cell.viewWithTag(2) as! UITextField).layer.cornerRadius = 4
                (cell.viewWithTag(2) as! UITextField).layer.borderColor = UIColor.red.cgColor
                (cell.viewWithTag(2) as! UITextField).layer.borderWidth = 1
                (cell.viewWithTag(2) as! UITextFieldFactory).placeholderColor = UIColor.red
                (cell.viewWithTag(2) as! UITextFieldFactory).placeholder = self.dataSource?["error_bank"] as? String
                (cell.viewWithTag(2) as! UITextField).text = ""
            }
            break
        case 2:
            cardText = (cell.viewWithTag(2) as! UITextField)
            (cell.viewWithTag(2) as! UITextField).keyboardType = .numberPad
            if self.dataSource?["error_card"] != nil && (self.dataSource?["error_card"] as! String).characters.count > 0 && self.showError{
                (cell.viewWithTag(2) as! UITextField).layer.cornerRadius = 4
                (cell.viewWithTag(2) as! UITextField).layer.borderColor = UIColor.red.cgColor
                (cell.viewWithTag(2) as! UITextField).layer.borderWidth = 1
                (cell.viewWithTag(2) as! UITextFieldFactory).placeholderColor = UIColor.red
                (cell.viewWithTag(2) as! UITextFieldFactory).placeholder = self.dataSource?["error_card"] as? String
                (cell.viewWithTag(2) as! UITextField).text = ""
            }
            break
        case 3:
            alipayText = (cell.viewWithTag(2) as! UITextField)
            if self.dataSource?["error_alipay"] != nil && (self.dataSource?["error_alipay"] as! String).characters.count > 0 && self.showError{
                (cell.viewWithTag(2) as! UITextField).layer.cornerRadius = 4
                (cell.viewWithTag(2) as! UITextField).layer.borderColor = UIColor.red.cgColor
                (cell.viewWithTag(2) as! UITextField).layer.borderWidth = 1
                (cell.viewWithTag(2) as! UITextFieldFactory).placeholderColor = UIColor.red
                (cell.viewWithTag(2) as! UITextFieldFactory).placeholder = self.dataSource?["error_alipay"] as? String
                (cell.viewWithTag(2) as! UITextField).text = ""
            }
            break
        case 4:
            weixinText = (cell.viewWithTag(2) as! UITextField)
            break
        case 5:
            bitcionText = (cell.viewWithTag(2) as! UITextField)
            if self.dataSource?["error_bitcoin"] != nil && (self.dataSource?["error_bitcoin"] as! String).characters.count > 0 && self.showError{
                (cell.viewWithTag(2) as! UITextField).layer.cornerRadius = 4
                (cell.viewWithTag(2) as! UITextField).layer.borderColor = UIColor.red.cgColor
                (cell.viewWithTag(2) as! UITextField).layer.borderWidth = 1
                (cell.viewWithTag(2) as! UITextFieldFactory).placeholderColor = UIColor.red
                (cell.viewWithTag(2) as! UITextFieldFactory).placeholder = self.dataSource?["error_bitcoin"] as? String
                (cell.viewWithTag(2) as! UITextField).text = ""
            }
            break
        default:
            break
        }
        return cell
    }
    
    func requestAccount(_ dic:NSDictionary?) {
        SVProgressHUD.show()
        NetworkModel.init(with: dic, url: "index.php?route=account/bank_info&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            SVProgressHUD.dismiss()
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                self.dataSource = dic
                self.accountArr = [["title":(self.dataSource?["text_bankinfo_name"] as! String),"placeholder":(self.dataSource?["name"] as! String)],
                                   ["title":(self.dataSource?["text_bankinfo_bank"] as! String),"placeholder":(self.dataSource?["bank"] as! String)],
                                   ["title":(self.dataSource?["text_bankinfo_card"] as! String),"placeholder":(self.dataSource?["card"] as! String)],
                                   ["title":(self.dataSource?["text_bankinfo_alipay"] as! String),"placeholder":(self.dataSource?["alipay"] as! String)],
                                   ["title":(self.dataSource?["text_bankinfo_wechat"] as! String),"placeholder":(self.dataSource?["wechat"] as! String)],
                                   ["title":(self.dataSource?["text_bankinfo_bitcoin"] as! String),"placeholder":(self.dataSource?["bitcoin"] as! String)]]
                self.title = self.dataSource?["text_bankinfo_title"] as? String
                self.saveBtn.setTitle(self.dataSource?["text_bankinfo_submit"] as? String, for: .normal)
                self.tableView.reloadData()
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure: { (request) in
            SVProgressHUD.dismiss()
            
        })
    }
    
    
}
