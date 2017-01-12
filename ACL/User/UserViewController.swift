//
//  UserViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class UserViewController: UITableViewController {
    
    var titleDic:NSDictionary = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的"
        let tabbar = self.tabBarController as! ACLTabBarViewController
        if tabbar.languageDic != nil && tabbar.languageDic?["menu"] != nil{
            self.title = (((tabbar.languageDic?["menu"] as! NSDictionary)[UserDefaults.standard.object(forKey: "language") as! String] as! NSArray) as! [String])[4]
        }
        titleDic = ["0":["基本信息","收款账户","安全设置","原点升级"],"1":["金额变动日志","新闻","反馈","ACL商场","关于ACL"]]
        if tabbar.languageDic != nil {
            titleDic = ["0":[(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_profile"] as! String,(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_bankinfo"] as! String,(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_security"] as! String,(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_upgrade"] as! String],"1":[(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_log"] as! String,(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_header_news"] as! String,(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_header_feedback"] as! String,(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_header_mall"] as! String,(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_header_meeting"] as! String]]
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }else{
            return 5
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 10))
        v.backgroundColor = UIColor.clear
        return v
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "user-icon-" + String(indexPath.row))
        (cell.viewWithTag(2) as! UILabel).text = (titleDic[String(indexPath.section)] as! NSArray)[indexPath.row] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "basePush", sender: indexPath)
                break
            case 1:
                self.requestVerify()
                break
            case 2:
                self.performSegue(withIdentifier: "safetyPush", sender: indexPath)
                break
            case 3:
                self.performSegue(withIdentifier: "updatePush", sender: indexPath)
                break
            default:
                break
            }
        }else{
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "moneyListPush", sender: indexPath)
                break
            case 1:
                self.performSegue(withIdentifier: "newsPush", sender: indexPath)
                break
            case 2:
                self.performSegue(withIdentifier: "feedbackPush", sender: indexPath)
                break
            case 3:
                let web = WebViewController.getInstance()
                web.url = "https://www.usacl.net"
                _ = self.navigationController?.pushViewController(web, animated: true)
                break
            case 4:
                self.performSegue(withIdentifier: "abortPush", sender: indexPath)
                break
            default:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "safetyPush" && sender == nil {
            let vc = segue.destination as! SafetyVerifyViewController
            vc.accountVerify = true
        }
    }
    
    func requestVerify() {
        SVProgressHUD.show()
        NetworkModel.init(with: [:], url: "index.php?route=account/bank_info&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            SVProgressHUD.dismiss()
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                if (dic["correct_verification"] as! NSNumber).intValue == 0 {
                    self.performSegue(withIdentifier: "safetyPush", sender: nil)
                }else{
                    self.performSegue(withIdentifier: "accountPush", sender: nil)
                }
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure: { (request) in
            
        })
    }
    
}
