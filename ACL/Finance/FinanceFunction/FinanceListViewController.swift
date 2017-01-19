//
//  FinanceListViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/1.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

enum FinanceType:Int {
    case earn               = 0
    case regist             = 1
    case registDeal         = 2
    case cash               = 3
    case cashDeal           = 4
    case usScore            = 5
}

class FinanceListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var pageBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    
    var dataSource:NSDictionary?
    var keys:NSArray?
    var page = 1
    var type:FinanceType = .earn
    var searchDic:[String:String]?
    var searchBar:UISearchBar?
    
    @IBAction func pageChangeValue(_ sender: UIButton) {
        if sender.tag == 1 {
            page = page - 1
        }else{
            page = page + 1
        }
        if page <= 1 {
            page = 1
            (sender.superview?.viewWithTag(1) as! UIButton).isEnabled = false
        }else{
            (sender.superview?.viewWithTag(1) as! UIButton).isEnabled = true
        }
        self.pageBtn.setTitle(String(page), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        searchBar?.showsCancelButton = true
        searchBar?.delegate = self
//        switch type {
//        case .earn:
//            searchBar?.placeholder = "在此搜索动态收益."
//            break
//        case .regist:
//            searchBar?.placeholder = "在此搜索注册币收支记录."
//            break
//        case .registDeal:
//            searchBar?.placeholder = "在此搜索动态收益."
//            break
//        case .cash:
//            searchBar?.placeholder = "在此搜索动态收益."
//            break
//        case .cashDeal:
//            searchBar?.placeholder = "在此搜索动态收益."
//            break
//        case .usScore:
//            searchBar?.placeholder = "在此搜索动态收益."
//            break
//        }
        self.navigationItem.titleView = searchBar
        
        self.pageBtn.layer.cornerRadius = 4
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.requestList(nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShow(_ notification:Notification) -> Void {
        let keyboardRect:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.tableViewBottom.constant = keyboardRect.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(_ notification:Notification) -> Void {
        UIView.animate(withDuration: 0.75, animations: ({
            self.tableViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }), completion: {(_ finish:Bool) -> Void in
            
        })
    }
    
    //MARK:- UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
        self.requestList(searchBar.text)
        searchBar.text = ""
    }
    
    //MARK:- UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if self.dataSource == nil {
                return 0
            }
            return 1
        }else{
            if self.dataSource != nil{
                switch type {
                case .earn:
                    if self.dataSource?["perday_bonus"] != nil {
                        return self.keys!.count
                    }
                    break
                case .regist:
                    if self.dataSource?["bonus_coins"] != nil {
                        return (self.dataSource?["bonus_coins"] as! NSArray).count
                    }
                case .registDeal:
                    if self.dataSource?["bonus_coins"] != nil {
                        return (self.dataSource?["bonus_coins"] as! NSArray).count
                    }
                case .cash:
                    if self.dataSource?["bonus_coins"] != nil {
                        return (self.dataSource?["bonus_coins"] as! NSArray).count
                    }
                case .cashDeal:
                    if self.dataSource?["bonus_coins"] != nil {
                        return (self.dataSource?["bonus_coins"] as! NSArray).count
                    }
                case .usScore:
                    if self.dataSource?["rewards"] != nil {
                        return (self.dataSource?["rewards"] as! NSArray).count
                    }
                    break
                }
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else {
            if self.dataSource == nil {
                return 0
            }
            return 49
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else{
            if self.dataSource == nil {
                return nil
            }
            switch type {
            case .earn:
                (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?["text_dynamic_detail"] as? String
                break
            case .regist:
                (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?["text_activation_record"] as? String
                break
            case .registDeal:
                (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?["text_activation_record"] as? String
                break
            case .cash:
                (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?["text_cash_record"] as? String
                break
            case .cashDeal:
                (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?["text_cash_record"] as? String
                break
            case .usScore:
                (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?["text_reward_record"] as? String
                break
            }
            return self.headerView
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if type == .usScore && indexPath.section == 0 {
            if self.dataSource != nil {
                if (self.dataSource?["enable_validate_transfer"] as! NSNumber).intValue == 1{
                    (cell.viewWithTag(3) as! UIButton).isUserInteractionEnabled = true
                    (cell.viewWithTag(3) as! UIButton).backgroundColor = UIColor.colorWithHexString(hex: "12B8F6")
                }else{
                    (cell.viewWithTag(3) as! UIButton).isUserInteractionEnabled = false
                    (cell.viewWithTag(3) as! UIButton).backgroundColor = UIColor.colorWithHexString(hex: "C4C2C3")
                }
                if (self.dataSource?["enable_return_coin"] as! NSNumber).intValue == 1{
                    (cell.viewWithTag(4) as! UIButton).isUserInteractionEnabled = true
                    (cell.viewWithTag(4) as! UIButton).backgroundColor = UIColor.colorWithHexString(hex: "12B8F6")
                }else{
                    (cell.viewWithTag(4) as! UIButton).isUserInteractionEnabled = false
                    (cell.viewWithTag(4) as! UIButton).backgroundColor = UIColor.colorWithHexString(hex: "C4C2C3")
                }
                if (self.dataSource?["enable_return_reward"] as! NSNumber).intValue == 1{
                    (cell.viewWithTag(5) as! UIButton).isUserInteractionEnabled = true
                    (cell.viewWithTag(5) as! UIButton).backgroundColor = UIColor.colorWithHexString(hex: "12B8F6")
                }else{
                    (cell.viewWithTag(5) as! UIButton).isUserInteractionEnabled = false
                    (cell.viewWithTag(5) as! UIButton).backgroundColor = UIColor.colorWithHexString(hex: "C4C2C3")
                }
                if (self.dataSource?["enable_credit_transfer"] as! NSNumber).intValue == 1{
                    (cell.viewWithTag(6) as! UIButton).isUserInteractionEnabled = true
                    (cell.viewWithTag(6) as! UIButton).backgroundColor = UIColor.colorWithHexString(hex: "12B8F6")
                }else{
                    (cell.viewWithTag(6) as! UIButton).isUserInteractionEnabled = false
                    (cell.viewWithTag(6) as! UIButton).backgroundColor = UIColor.colorWithHexString(hex: "C4C2C3")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        if indexPath.section == 0 {
            switch type {
            case .earn:
                cellIdentifier = "earnCell"
                break
            case .regist:
                cellIdentifier = "registCell"
                break
            case .registDeal:
                cellIdentifier = "registCell"
                break
            case .cash:
                cellIdentifier = "cashCell"
                break
            case .cashDeal:
                cellIdentifier = "cashCell"
                break
            case .usScore:
                cellIdentifier = "usCell"
                break
            }
        }else{
            switch type {
            case .earn:
                cellIdentifier = "Cell1"
                break
            case .regist:
                cellIdentifier = "Cell2"
                break
            case .registDeal:
                cellIdentifier = "Cell2"
                break
            case .cash:
                cellIdentifier = "Cell2"
                break
            case .cashDeal:
                cellIdentifier = "Cell2"
                break
            case .usScore:
                cellIdentifier = "Cell2"
                break
            }
        }
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if indexPath.section == 0{
            switch type {
            case .earn:
                (cell.viewWithTag(1) as! UILabel).text = self.dataSource?["text_dynamic_title"] as? String
                (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_dynamic_total"] as! String + "："
                (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_dynamic_referal"] as! String + "："
                (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_dynamic_duipeng"] as! String + "："
                (cell.viewWithTag(14) as! UILabel).text = self.dataSource?["text_dynamic_register"] as! String + "："
                (cell.viewWithTag(15) as! UILabel).text = self.dataSource?["text_dynamic_leader"] as! String + "："
                (cell.viewWithTag(21) as! UILabel).text = ((self.dataSource?["bonus"] as! NSDictionary)["total"] as? String)
                (cell.viewWithTag(22) as! UILabel).text = ((self.dataSource?["bonus"] as! NSDictionary)["type1"] as? String)
                (cell.viewWithTag(23) as! UILabel).text = ((self.dataSource?["bonus"] as! NSDictionary)["type2"] as? String)
                (cell.viewWithTag(24) as! UILabel).text = ((self.dataSource?["bonus"] as! NSDictionary)["type3"] as? String)
                (cell.viewWithTag(25) as! UILabel).text = ((self.dataSource?["bonus"] as! NSDictionary)["type4"] as? String)
                break
            case .regist:
                (cell.viewWithTag(1) as! UILabel).text = self.dataSource?["text_activation_coin"] as? String
                (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_activation_hold"] as? String
                (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_activation_totalincome"] as? String
                (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_activation_totaloutcome"] as? String
                (cell.viewWithTag(21) as! UILabel).text = (self.dataSource?["active_coin"] as? String)
                (cell.viewWithTag(22) as! UILabel).text = (self.dataSource?["total_income_coin"] as? String)
                (cell.viewWithTag(23) as! UILabel).text = (self.dataSource?["total_sell_coin"] as? String)
                (cell.viewWithTag(3) as! UIButton).setTitle(self.dataSource?["text_activation_transfer"] as? String, for: .normal)
                (cell.viewWithTag(3) as! UIButton).layer.cornerRadius = 4
                (cell.viewWithTag(3) as! UIButton).addTarget(self, action: #selector(saleBtnDidClick(_:)), for: .touchUpInside)
                break
            case .registDeal:
                (cell.viewWithTag(1) as! UILabel).text = self.dataSource?["text_activation_coin"] as? String
                (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_activation_hold"] as? String
                (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_activation_totalincome"] as? String
                (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_activation_totaloutcome"] as? String
                (cell.viewWithTag(21) as! UILabel).text = (self.dataSource?["all_coin"] as? String)
                (cell.viewWithTag(22) as! UILabel).text = (self.dataSource?["total_income_coin"] as? String)
                (cell.viewWithTag(23) as! UILabel).text = (self.dataSource?["total_sell_coin"] as? String)
                (cell.viewWithTag(3) as! UIButton).setTitle(self.dataSource?["text_customer_activation_transfer"] as? String, for: .normal)
                (cell.viewWithTag(3) as! UIButton).layer.cornerRadius = 4
                (cell.viewWithTag(3) as! UIButton).addTarget(self, action: #selector(searchTimeBtnDidClick(_:)), for: .touchUpInside)
                break
            case .cash:
                (cell.viewWithTag(1) as! UILabel).text = self.dataSource?["text_cash_coin"] as? String
                (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_cash_cashcoin"] as? String
                (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_cash_totalsell"] as? String
                (cell.viewWithTag(21) as! UILabel).text = (self.dataSource?["all_coin"] as? String)
                (cell.viewWithTag(22) as! UILabel).text = (self.dataSource?["total_sell_coin"] as? String)
                let str = self.dataSource?["total_transfer_coin"] as! NSObject
                var tempStr = ""
                if str.isKind(of: NSNull.self){
                    tempStr = "0"
                }else if str.isKind(of: NSString.self){
                    tempStr = self.dataSource?["total_transfer_coin"] as! String
                }
                (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_totaltransferrc"] as? String
                (cell.viewWithTag(14) as! UILabel).text = self.dataSource?["text_cash_totalbuy"] as? String
                (cell.viewWithTag(23) as! UILabel).text = tempStr
                (cell.viewWithTag(24) as! UILabel).text = (self.dataSource?["total_income_coin"] as? String)
                (cell.viewWithTag(3) as! UIButton).setTitle(self.dataSource?["text_cash_sell"] as? String, for: .normal)
                (cell.viewWithTag(3) as! UIButton).layer.cornerRadius = 4
                (cell.viewWithTag(4) as! UIButton).setTitle(self.dataSource?["text_cash_transfer"] as? String, for: .normal)
                (cell.viewWithTag(4) as! UIButton).layer.cornerRadius = 4
                (cell.viewWithTag(3) as! UIButton).addTarget(self, action: #selector(saleBtnDidClick(_:)), for: .touchUpInside)
                (cell.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(saleBtnDidClick(_:)), for: .touchUpInside)
                break
            case .cashDeal:
                (cell.viewWithTag(1) as! UILabel).text = self.dataSource?["text_cash_record"] as? String
                (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_cash_cashcoin"] as? String
                (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_cash_totalsell"] as? String
                (cell.viewWithTag(21) as! UILabel).text = (self.dataSource?["all_coin"] as? String)
                (cell.viewWithTag(22) as! UILabel).text = (self.dataSource?["total_sell_coin"] as? String)
                let str = self.dataSource?["total_transfer_coin"] as! NSObject
                var tempStr = ""
                if str.isKind(of: NSNull.self){
                    tempStr = "0"
                }else if str.isKind(of: NSString.self){
                    tempStr = self.dataSource?["total_transfer_coin"] as! String
                }
                (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_totaltransferrc"] as? String
                (cell.viewWithTag(14) as! UILabel).text = self.dataSource?["text_cash_totalbuy"] as? String
                (cell.viewWithTag(23) as! UILabel).text = tempStr
                (cell.viewWithTag(24) as! UILabel).text = (self.dataSource?["total_income_coin"] as? String)
                (cell.viewWithTag(3) as! UIButton).setTitle(self.dataSource?["text_cash_sell"] as? String, for: .normal)
                (cell.viewWithTag(3) as! UIButton).layer.cornerRadius = 4
                (cell.viewWithTag(4) as! UIButton).setTitle(self.dataSource?["text_cash_transfer"] as? String, for: .normal)
                (cell.viewWithTag(4) as! UIButton).layer.cornerRadius = 4
                (cell.viewWithTag(3) as! UIButton).addTarget(self, action: #selector(saleBtnDidClick(_:)), for: .touchUpInside)
                (cell.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(saleBtnDidClick(_:)), for: .touchUpInside)
                break
            case .usScore:
                (cell.viewWithTag(1) as! UILabel).text = self.dataSource?["text_reward_title"] as? String
                (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_reward_hold"] as! String + ":"// + (self.dataSource?["all_coin"] as! String)
                (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_reward_totalincome"] as! String + ":"//+ (self.dataSource?["total_income_coin"] as! String)
                (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_total_transfer"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
                (cell.viewWithTag(14) as! UILabel).text = self.dataSource?["text_reward_totaloutcome"] as! String + ":"//+ (self.dataSource?["total_sell_coin"] as! String)
                (cell.viewWithTag(21) as! UILabel).text = (self.dataSource?["rewards_total"] as? String)
                (cell.viewWithTag(22) as! UILabel).text = (self.dataSource?["income_rewards_total"] as? String)
                (cell.viewWithTag(23) as! UILabel).text = (self.dataSource?["transfer_total"] as? String)
                (cell.viewWithTag(24) as! UILabel).text = (self.dataSource?["spent_rewards"] as? String)
                (cell.viewWithTag(3) as! UIButton).setTitle(self.dataSource?["text_reward_transfer"] as? String, for: .normal)
                (cell.viewWithTag(3) as! UIButton).layer.cornerRadius = 4
                (cell.viewWithTag(4) as! UIButton).setTitle(self.dataSource?["text_return_coin"] as? String, for: .normal)
                (cell.viewWithTag(4) as! UIButton).layer.cornerRadius = 4
                (cell.viewWithTag(5) as! UIButton).setTitle(self.dataSource?["text_reward_storecredit"] as? String, for: .normal)
                (cell.viewWithTag(5) as! UIButton).layer.cornerRadius = 4
                (cell.viewWithTag(6) as! UIButton).setTitle(self.dataSource?["text_return_reward"] as? String, for: .normal)
                (cell.viewWithTag(6) as! UIButton).layer.cornerRadius = 4
                (cell.viewWithTag(3) as! UIButton).addTarget(self, action: #selector(saleBtnDidClick(_:)), for: .touchUpInside)
                (cell.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(saleBtnDidClick(_:)), for: .touchUpInside)
                (cell.viewWithTag(5) as! UIButton).addTarget(self, action: #selector(saleBtnDidClick(_:)), for: .touchUpInside)
                (cell.viewWithTag(6) as! UIButton).addTarget(self, action: #selector(saleBtnDidClick(_:)), for: .touchUpInside)
                break
            }
        }else{
            var dic:NSDictionary?
            if type == .earn {
                if indexPath.row % 2 == 0 {
                    cell.contentView.backgroundColor = UIColor.colorWithHexString(hex: "f9f5f5")
                }else{
                    cell.contentView.backgroundColor = UIColor.white
                }
                dic = (self.dataSource?["perday_bonus"] as! NSDictionary)[(self.keys?[indexPath.row] as! String)] as? NSDictionary
                (cell.viewWithTag(2) as! UILabel).text = self.keys?[indexPath.row] as? String
                (cell.viewWithTag(4) as! UILabel).text = dic?["total"] as? String
            }else if type == .regist || type == .registDeal {
                cell.viewWithTag(3)?.layer.cornerRadius = 4
                dic = (self.dataSource?["bonus_coins"] as! NSArray)[indexPath.row] as? NSDictionary
                (cell.viewWithTag(1) as! UILabel).text = dic?["date_added"] as? String
                (cell.viewWithTag(2) as! UILabel).text = dic?["amount"] as? String
                (cell.viewWithTag(3) as! UILabel).text = ""
                (cell.viewWithTag(4) as! UILabel).text = dic?["show"] as? String
            }else if type == .cash || type == .cashDeal {
                cell.viewWithTag(3)?.layer.cornerRadius = 4
                cell.viewWithTag(4)?.layer.cornerRadius = 4
                dic = (self.dataSource?["bonus_coins"] as! NSArray)[indexPath.row] as? NSDictionary
                (cell.viewWithTag(1) as! UILabel).text = dic?["date_added"] as? String
                (cell.viewWithTag(2) as! UILabel).text = dic?["coin_id"] as? String
                (cell.viewWithTag(3) as! UILabel).text = dic?["amount"] as? String
                (cell.viewWithTag(4) as! UILabel).text = dic?["show"] as? String
            }else{
                dic = (self.dataSource?["rewards"] as! NSArray)[indexPath.row] as? NSDictionary
                (cell.viewWithTag(1) as! UILabel).text = dic?["date_added"] as? String
                (cell.viewWithTag(2) as! UILabel).text = dic?["amount"] as? String
//                (cell.viewWithTag(3) as! UILabel).text = dic?["amount"] as? String
                cell.viewWithTag(3)?.isHidden = true
                (cell.viewWithTag(4) as! UILabel).text = dic?["transaction_type"] as? String
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "detailPush", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "detailPush" {
            let earn = segue.destination as! EarnDetailViewController
            earn.dataSource = self.dataSource
            earn.indexPath = (sender as? IndexPath)!
            earn.type = self.type
        }
    }
    
    func searchTimeBtnDidClick(_ sender:UIButton) -> Void {
        let vc = FinanceTimeViewController.getInstance()
        vc.dataSource = self.dataSource
        vc.complete = {(dic) -> Void in
            self.searchDic = dic
            self.requestList(nil)
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func saleBtnDidClick(_ sender:UIButton) -> Void {
        let cell:UITableViewCell? = Helpers.findSuperViewClass(UITableViewCell.self, with: sender) as? UITableViewCell
        if cell != nil {
            let indexPath = self.tableView.indexPath(for: cell!)
            let deal:FinanceDealViewController = FinanceDealViewController.getInstance()
            deal.dataSource = self.dataSource
            deal.type = self.type
            if self.type == .usScore {
                deal.usType = usDealType(rawValue: sender.tag)
            }
            deal.indexPath = indexPath
            if sender.tag == 3 && (type == .cash || type == .cashDeal) {
                deal.needSection = true
            }
            _ = self.navigationController?.pushViewController(deal, animated: true)
        }
    }
    
    func requestList(_ searchText:String?) {
        SVProgressHUD.show()
        var url = ""
        var dic:NSDictionary = [:]
        let text = searchText ?? ""
        switch type {
        case .earn:
            url = "index.php?route=finance/dynamic_profit&token="
            dic = [:]
            break
        case .regist:
            url = "index.php?route=finance/activation&token="
            dic = ["page":"1","nickname":text,"amount":"","account_password":""]
            break
        case .registDeal:
            url = "index.php?route=finance/expenditure&token="
            dic = ["transfer_type":"1","nickname":text,"start_date":"2016-01-01","start_date":""]
            if searchDic != nil {
                dic = ["transfer_type":(searchDic?["1"])!,"nickname":(searchDic?["0"])!,"start_date":(searchDic?["2"])!,"end_date":(searchDic?["3"])!]
            }
            break
        case .cash:
            url = "index.php?route=finance/coin&token="
            dic = [:]
            break
        case .cashDeal:
            url = "index.php?route=finance/coin_deal&token="
            dic = [:]
            break
        case .usScore:
            url = "index.php?route=finance/reward&token="
            dic = [:]
            break
        }
        url = url + (UserDefaults.standard.object(forKey: "token") as? String)!
        NetworkModel.init(with: dic, url: url, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                SVProgressHUD.dismiss()
                self.dataSource = dic
                if self.type == FinanceType.earn && self.dataSource?["perday_bonus"] != nil{
                    self.keys = (self.dataSource?["perday_bonus"] as! NSDictionary).allKeys as NSArray?
                    self.keys =  self.keys?.sortedArray(using: #selector(NSDecimalNumber.compare(_:))) as NSArray?
                }
                self.tableView.reloadData()
                
                
                if self.dataSource != nil{
                    self.searchBar?.placeholder = self.dataSource?["text_search"] as? String
                    switch self.type {
                    case .earn:
                        if self.dataSource?["perday_bonus"] != nil {
                            if self.dataSource != nil && self.keys!.count > 20 {
                                self.footerView.isHidden = false
                            }else{
                                self.footerView.isHidden = true
                            }
                        }
                        break
                    case .regist:
                        if self.dataSource?["bonus_coins"] != nil {
                            if self.dataSource != nil && (self.dataSource?["bonus_coins"] as! NSArray).count > 20 {
                                self.footerView.isHidden = false
                            }else{
                                self.footerView.isHidden = true
                            }
                        }
                    case .registDeal:
                        if self.dataSource?["bonus_coins"] != nil {
                            if self.dataSource != nil && (self.dataSource?["bonus_coins"] as! NSArray).count > 20 {
                                self.footerView.isHidden = false
                            }else{
                                self.footerView.isHidden = true
                            }
                        }
                    case .cash:
                        if self.dataSource?["bonus_coins"] != nil {
                            if self.dataSource != nil && (self.dataSource?["bonus_coins"] as! NSArray).count > 20 {
                                self.footerView.isHidden = false
                            }else{
                                self.footerView.isHidden = true
                            }
                        }
                    case .cashDeal:
                        if self.dataSource?["bonus_coins"] != nil {
                            if self.dataSource != nil && (self.dataSource?["bonus_coins"] as! NSArray).count > 20 {
                                self.footerView.isHidden = false
                            }else{
                                self.footerView.isHidden = true
                            }
                        }
                    case .usScore:
                        if self.dataSource?["rewards"] != nil {
                            if self.dataSource != nil && (self.dataSource?["rewards"] as! NSArray).count > 20 {
                                self.footerView.isHidden = false
                            }else{
                                self.footerView.isHidden = true
                            }
                        }
                        break
                    }
                }
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
            
        }, failure: { (request) in
            SVProgressHUD.dismiss()
        })
    }
    
}
