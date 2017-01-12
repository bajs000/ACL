//
//  UpdateStockViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/1.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class UpdateStockViewController: UITableViewController {
    
    @IBOutlet var headerView: UIView!
    var dataSource:NSDictionary?
    var keys:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.requestUpdate()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.dataSource == nil {
                return 0
            }
            return 1
        }else{
            if self.dataSource == nil {
                return 0
            }
            return (self.keys?.count)!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 49
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else{
            if self.dataSource != nil {
                (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?["text_upgrade_title"] as! String + " " + (self.dataSource?["text_upgrade_operate"] as! String)
            }
            return self.headerView
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier:String?
        if indexPath.section == 0 {
            cellIdentifier = "updateCell"
        }else{
            cellIdentifier = "Cell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier!, for: indexPath)
        if indexPath.section == 1 {
            if indexPath.row % 2 == 0 {
                cell.contentView.backgroundColor = UIColor.colorWithHexString(hex: "f9f5f5")
            }else{
                cell.contentView.backgroundColor = UIColor.white
            }
            let dic = (self.dataSource?["upgrade_total"] as! NSDictionary)[self.keys?[indexPath.row] as! String] as! [String:Any]
            (cell.viewWithTag(2) as! UILabel).text = dic["rank"] as? String
            (cell.viewWithTag(3) as! UILabel).text = dic["amount"] as? String
            (cell.viewWithTag(5) as! UIButton).layer.cornerRadius = 2
            if (dic["show_upgrade_button"] as? NSNumber)?.intValue == 1 {
                (cell.viewWithTag(5) as! UIButton).isHidden = false
                (cell.viewWithTag(4) as! UILabel).isHidden = true
                (cell.viewWithTag(4) as! UILabel).text = ""
                (cell.viewWithTag(5) as! UIButton).setTitle(self.dataSource?["text_upgrade_upgrade"] as? String, for: .normal)
            }else if (dic["show_upgrade_button"] as? NSNumber)?.intValue == -1{
                (cell.viewWithTag(5) as! UIButton).isHidden = true
                (cell.viewWithTag(4) as! UILabel).isHidden = false
                (cell.viewWithTag(4) as! UILabel).text = self.dataSource?["text_upgrade_close"] as? String
                (cell.viewWithTag(5) as! UIButton).setTitle("", for: .normal)
            }else{
                (cell.viewWithTag(5) as! UIButton).isHidden = true
                (cell.viewWithTag(4) as! UILabel).isHidden = true
                (cell.viewWithTag(4) as! UILabel).text = self.dataSource?["text_upgrade_close"] as? String
                (cell.viewWithTag(5) as! UIButton).setTitle(self.dataSource?["text_upgrade_upgrade"] as? String, for: .normal)
            }
        }else{
            cell.contentView.backgroundColor = UIColor.white
            let background = cell.viewWithTag(9)
            background?.layer.borderColor = UIColor.RGB(red: 236.0, green: 235.0, blue: 235.0, alpha: 1.0).cgColor
            background?.layer.borderWidth = 1
            background?.layer.shadowColor = UIColor.black.cgColor
            background?.layer.shadowOffset = CGSize(width: 2, height: 2)
            background?.layer.shadowOpacity = 0.2
            (cell.viewWithTag(1) as! UILabel).text = self.dataSource?["text_upgrade_title"] as? String
            (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_upgrade_currentrank"] as! String + (self.dataSource?["current_rank"] as! String) + (self.dataSource?["text_upgrade_star"] as! String)
            (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_upgrade_banlance"] as! String + (self.dataSource?["active_coin"] as! String)
        }
        return cell
    }
    
    func requestUpdate(){
        SVProgressHUD.show()
        NetworkModel.init(with: ["account_password":"Abcd123","rank":"2"], url: "index.php?route=account/upgrade_account&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                SVProgressHUD.dismiss()
                self.dataSource = dic
                if self.dataSource != nil && self.dataSource?["upgrade_total"] != nil{
                    self.keys = (self.dataSource?["upgrade_total"] as! NSDictionary).allKeys as NSArray?
                    self.keys = self.keys?.sortedArray(using: #selector(NSDecimalNumber.compare(_:))) as NSArray?
                }
                self.tableView.reloadData()
                self.title = dic["text_upgrade_title"] as? String
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure:{(request) in
            print(request.error!)
        })
    }
    
}
