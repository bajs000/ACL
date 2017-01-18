//
//  StockDetailViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/29.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

enum StockDetailType {
    case Split
    case Stock
    case Redelivery
}

class StockDetailViewController: UITableViewController {
    
    var type:StockDetailType?
    var dataSource:NSDictionary?
    var currentIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        if type == StockDetailType.Split{
            self.requestDetail()
        }else{
            self.title = self.dataSource?["text_table_detail"] as? String
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource != nil{
            if type == StockDetailType.Split{
                return (self.dataSource?["split_history"] as! NSArray).count
            }else if type == StockDetailType.Stock || type == StockDetailType.Redelivery{
                return (self.dataSource?["shares"] as! NSArray).count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier:String?
        if type == StockDetailType.Split {
            cellIdentifier = "splitCell"
        }else{
            cellIdentifier = "stockCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier!, for: indexPath)
        let background = cell.viewWithTag(2)
        background?.layer.borderColor = UIColor.RGB(red: 236.0, green: 235.0, blue: 235.0, alpha: 1.0).cgColor
        background?.layer.borderWidth = 1
        background?.layer.shadowColor = UIColor.black.cgColor
        background?.layer.shadowOffset = CGSize(width: 2, height: 2)
        background?.layer.shadowOpacity = 0.2
        
        if type == StockDetailType.Split{
            let dic = (self.dataSource?["split_history"] as! NSArray)[indexPath.row] as! NSDictionary
            (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_amount_before"] as! String + "："
            (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_split_time"] as! String + "："
            (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_split_price"] as! String + "："
            (cell.viewWithTag(14) as! UILabel).text = self.dataSource?["text_split_afterprice"] as! String + "："
            (cell.viewWithTag(15) as! UILabel).text = self.dataSource?["text_split_date"] as! String + "："
            (cell.viewWithTag(16) as! UILabel).text = self.dataSource?["text_amount_after"] as! String + "："/* + (dic["multiple"] as! String)*/
            (cell.viewWithTag(17) as! UILabel).text = self.dataSource?["text_split_status"] as! String + "："/* + (dic["multiple"] as! String)*/
            (cell.viewWithTag(21) as! UILabel).text = (dic["before_share_num"] as? String)
            (cell.viewWithTag(22) as! UILabel).text = (dic["multiple"] as? String)
            (cell.viewWithTag(23) as! UILabel).text = (dic["before_price"] as? String)
            (cell.viewWithTag(24) as! UILabel).text = (dic["after_price"] as? String)
            (cell.viewWithTag(25) as! UILabel).text = (dic["date_added"] as? String)
            (cell.viewWithTag(26) as! UILabel).text = (dic["after_share_num"] as? String)
            (cell.viewWithTag(27) as! UILabel).text = (dic["split_history_id"] as? String)
        }else if type == StockDetailType.Stock || type == StockDetailType.Redelivery{
            let dic = (self.dataSource?["shares"] as! NSArray)[(currentIndexPath?.row)!] as! NSDictionary
            (cell.viewWithTag(1) as! UILabel).text = dic["date_added"] as? String
            (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_orderid"] as! String + "："
            (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_operate"] as! String + "："
            (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_trade_amount"] as! String + "："
            (cell.viewWithTag(14) as! UILabel).text = self.dataSource?["text_trade_price"] as! String + "："
            (cell.viewWithTag(15) as! UILabel).text = self.dataSource?["text_allotment_date"] as! String + "："
            (cell.viewWithTag(16) as! UILabel).text = self.dataSource?["text_release_date"] as! String + "："
            (cell.viewWithTag(17) as! UILabel).text = self.dataSource?["text_status"] as! String + "："
            
            (cell.viewWithTag(21) as! UILabel).text = (dic["share_id"] as? String)
            (cell.viewWithTag(22) as! UILabel).text = (dic["deal_name"] as? String)
            (cell.viewWithTag(23) as! UILabel).text = (dic["share_num"] as? String)
            (cell.viewWithTag(24) as! UILabel).text = (dic["share_price"] as? String)
            (cell.viewWithTag(25) as! UILabel).text = (dic["allotment_date"] as? String)
            (cell.viewWithTag(26) as! UILabel).text = (dic["unfreeze_date"] as? String)
            (cell.viewWithTag(27) as! UILabel).text = (dic["status"] as? String)
            
        }
        return cell
    }
    
    func requestDetail() {
        SVProgressHUD.show()
        NetworkModel.init(with: [:], url: "index.php?route=share/split&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                SVProgressHUD.dismiss()
                self.dataSource = dic
                self.tableView.reloadData()
                if self.type == StockDetailType.Split{
                    self.title = dic["title"] as? String
                }else if self.type == StockDetailType.Stock {
                    self.title = "股份详情"
                }else{
                    self.title = "复投详情"
                }
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure:{(request) in
            print(request.error!)
            SVProgressHUD.dismiss()
        })
    }
    
}
