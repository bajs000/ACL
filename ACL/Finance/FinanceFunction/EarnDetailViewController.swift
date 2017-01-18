//
//  EarnDetailViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/1.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class EarnDetailViewController: UITableViewController {
    
    var dataSource:NSDictionary?
    var indexPath:IndexPath?
    var type:FinanceType = .earn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收益详情"
        switch self.type {
        case .earn:
            self.title = self.dataSource?["text_dynamic_title"] as? String
            break
        case .regist:
            self.title = self.dataSource?["text_table_detail"] as? String
            break
        case .registDeal:
            self.title = self.dataSource?["text_table_detail"] as? String
            break
        case .cash:
            self.title = self.dataSource?["text_cash_record"] as? String
            break
        case .cashDeal:
            self.title = self.dataSource?["text_cash_record"] as? String
            break
        case .usScore:
            self.title = self.dataSource?["text_reward_record"] as? String
            break
        }
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if self.type == .earn {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let dic = self.dataSource?["perday_bonus"] as! NSDictionary
            var keys = dic.allKeys as NSArray
            keys = (keys.sortedArray(using: #selector(NSDecimalNumber.compare(_:))) as NSArray)
            (cell?.viewWithTag(1) as! UILabel).text = keys[(self.indexPath?.row)!] as? String
            (cell?.viewWithTag(11) as! UILabel).text = self.dataSource?["text_dynamic_referal"] as! String + ":"// + (self.dataSource?["all_coin"] as! String)
            (cell?.viewWithTag(12) as! UILabel).text = self.dataSource?["text_dynamic_duipeng"] as! String + ":"//+ (self.dataSource?["total_income_coin"] as! String)
            (cell?.viewWithTag(13) as! UILabel).text = self.dataSource?["text_dynamic_register"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
            (cell?.viewWithTag(14) as! UILabel).text = self.dataSource?["text_dynamic_leader"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
            (cell?.viewWithTag(15) as! UILabel).text = self.dataSource?["text_dynamic_subtotal"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
            let tempDic = dic[(cell?.viewWithTag(1) as! UILabel).text ?? ""] as! NSDictionary
            (cell?.viewWithTag(21) as! UILabel).text = tempDic["total"] as? String
            (cell?.viewWithTag(22) as! UILabel).text = tempDic["type1"] as? String
            (cell?.viewWithTag(23) as! UILabel).text = tempDic["type2"] as? String
            (cell?.viewWithTag(24) as! UILabel).text = tempDic["type3"] as? String
            (cell?.viewWithTag(25) as! UILabel).text = tempDic["type4"] as? String
            
        }else if self.type == .regist || self.type == .registDeal {
            cell = tableView.dequeueReusableCell(withIdentifier: "registCell", for: indexPath)
            let dic = (self.dataSource?["bonus_coins"] as! NSArray)[(self.indexPath?.row)!] as! NSDictionary
            (cell?.viewWithTag(1) as! UILabel).text = dic["date_added"] as? String
            (cell?.viewWithTag(11) as! UILabel).text = self.dataSource?["text_activation_transferamount"] as! String + ":"// + (self.dataSource?["all_coin"] as! String)
            (cell?.viewWithTag(12) as! UILabel).text = self.dataSource?["text_activation_detail"] as! String + ":"//+ (self.dataSource?["total_income_coin"] as! String)
            if self.dataSource?["text_activation_status"] != nil {
                (cell?.viewWithTag(13) as! UILabel).text = self.dataSource?["text_activation_status"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
            }
            (cell?.viewWithTag(21) as! UILabel).text = dic["amount"] as? String
            (cell?.viewWithTag(22) as! UILabel).text = dic["show"] as? String
            (cell?.viewWithTag(23) as! UILabel).text = dic["status"] as? String
        }else if self.type == .cash || self.type == .cashDeal{
            cell = tableView.dequeueReusableCell(withIdentifier: "cashCell", for: indexPath)
            let dic = (self.dataSource?["bonus_coins"] as! NSArray)[(self.indexPath?.row)!] as! NSDictionary
            (cell?.viewWithTag(1) as! UILabel).text = dic["date_added"] as? String
            (cell?.viewWithTag(11) as! UILabel).text = self.dataSource?["text_cash_orderid"] as! String + ":"// + (self.dataSource?["all_coin"] as! String)
            (cell?.viewWithTag(12) as! UILabel).text = self.dataSource?["text_cash_amount"] as! String + ":"//+ (self.dataSource?["total_income_coin"] as! String)
            (cell?.viewWithTag(13) as! UILabel).text = self.dataSource?["text_cash_detail"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
            (cell?.viewWithTag(14) as! UILabel).text = self.dataSource?["text_cash_status"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
            (cell?.viewWithTag(15) as! UILabel).text = self.dataSource?["text_cash_timeleft"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
            (cell?.viewWithTag(16) as! UILabel).text = self.dataSource?["text_cash_operate"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
            (cell?.viewWithTag(21) as! UILabel).text = dic["coin_id"] as? String
            (cell?.viewWithTag(22) as! UILabel).text = dic["amount"] as? String
            (cell?.viewWithTag(23) as! UILabel).text = dic["show"] as? String
            (cell?.viewWithTag(24) as! UILabel).text = dic["status"] as? String
            (cell?.viewWithTag(25) as! UILabel).text = dic["remain_hours"] as? String
            (cell?.viewWithTag(26) as! UILabel).text = dic["detail"] as? String
            
            cell?.viewWithTag(100)?.isHidden = true
            if dic["trade_type"] != nil && (dic["trade_type"] as! String).characters.count > 0{
                cell?.viewWithTag(100)?.isHidden = false
                
                var moreTitle = "详细"
                if UserDefaults.standard.object(forKey: "language") != nil {
                    if (UserDefaults.standard.object(forKey: "language") as! String) == "cn" {
                        moreTitle = "详细"
                    }else{
                        moreTitle = "Detail"
                    }
                }
                (cell?.viewWithTag(100) as! UILabel).text = moreTitle
            }
            
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "registCell", for: indexPath)
            let dic = (self.dataSource?["rewards"] as! NSArray)[(self.indexPath?.row)!] as! NSDictionary
            (cell?.viewWithTag(1) as! UILabel).text = dic["date_added"] as? String
            (cell?.viewWithTag(11) as! UILabel).text = self.dataSource?["text_reward_amount"] as! String + ":"// + (self.dataSource?["all_coin"] as! String)
            (cell?.viewWithTag(12) as! UILabel).text = self.dataSource?["text_reward_detail"] as! String + ":"//+ (self.dataSource?["total_income_coin"] as! String)
            if self.dataSource?["text_activation_status"] != nil {
                (cell?.viewWithTag(13) as! UILabel).text = self.dataSource?["text_activation_status"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
            }
            (cell?.viewWithTag(21) as! UILabel).text = dic["amount"] as? String
            (cell?.viewWithTag(22) as! UILabel).text = dic["transaction_type"] as? String
            (cell?.viewWithTag(23) as! UILabel).text = dic["status"] as? String
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = (self.dataSource?["bonus_coins"] as! NSArray)[(self.indexPath?.row)!] as! NSDictionary
        if dic["trade_type"] != nil {
            if (dic["trade_type"] as! String).characters.count > 0 {
                let vc = CashDetailViewController.getInstance()
                vc.dataSource = self.dataSource
                vc.currentIndexPath = self.indexPath
                _ = self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
