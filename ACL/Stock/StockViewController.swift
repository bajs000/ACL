//
//  StockViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/29.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

enum StockType {
    case Mine
    case Cast
}

class StockViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var pageBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    
    var searchBar:UISearchBar?
    var dataSource:NSDictionary?
    var page = 1
    var type:StockType?
    
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
        searchBar?.placeholder = "在此搜索股份操作记录."
        self.navigationItem.titleView = searchBar
        
        let btn = Helpers.findClass(UIButton.self, at: searchBar!) as! UIButton
        if UserDefaults.standard.object(forKey: "language") != nil {
            if (UserDefaults.standard.object(forKey: "language") as! String) == "en" {
                btn.setTitle("search", for: .normal)
            }else {
                btn.setTitle("搜索", for: .normal)
            }
        }else{
            btn.setTitle("搜索", for: .normal)
        }
        
        self.pageBtn.layer.cornerRadius = 4
        
        
        
        self.requestStock()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
        searchBar.text = ""
    }
    
    //MARK:- UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if  self.dataSource == nil {
                return 0
            }
            return 1
        }else{
            if self.dataSource != nil{
//                if type == StockType.Mine {
                    return (self.dataSource?["shares"] as! NSArray).count
//                }
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section == 0 {
            return 0
        }
        return 49
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else{
            (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?["text_table_title"] as? String
            return self.headerView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if indexPath.section == 0 {
            if type == StockType.Mine {
                cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
                let btn = cell?.viewWithTag(3)
                btn?.layer.cornerRadius = 4
                let background = cell?.viewWithTag(2)
                background?.layer.borderColor = UIColor.RGB(red: 236.0, green: 235.0, blue: 235.0, alpha: 1.0).cgColor
                background?.layer.borderWidth = 1
                background?.layer.shadowColor = UIColor.black.cgColor
                background?.layer.shadowOffset = CGSize(width: -3, height: 3)
                background?.layer.shadowOpacity = 0.2
                
                (btn as! UIButton).addTarget(self, action: #selector(sellStockBtnDidClick(_:)), for: .touchUpInside)
                (btn as! UIButton).setTitle(self.dataSource?["btn_handsell"] as? String, for: .normal)
                
                (cell?.viewWithTag(1) as! UILabel).text = self.dataSource?["title"] as? String
                (cell?.viewWithTag(11) as! UILabel).text = self.dataSource?["text_share_hold"] as? String
                (cell?.viewWithTag(12) as! UILabel).text = self.dataSource?["text_share_price"] as? String
                (cell?.viewWithTag(13) as! UILabel).text = self.dataSource?["text_share_value"] as? String
                (cell?.viewWithTag(14) as! UILabel).text = self.dataSource?["text_share_sell"] as? String
                (cell?.viewWithTag(15) as! UILabel).text = self.dataSource?["text_share_frozen"] as? String
                (cell?.viewWithTag(16) as! UILabel).text = self.dataSource?["text_share_totalsell"] as? String
                (cell?.viewWithTag(17) as! UILabel).text = self.dataSource?["text_share_curentlimit"]  as? String
                (cell?.viewWithTag(21) as! UILabel).text = (self.dataSource?["total_num"] as? String)
                (cell?.viewWithTag(22) as! UILabel).text = (self.dataSource?["current_share_price"] as?String)
                (cell?.viewWithTag(23) as! UILabel).text = (self.dataSource?["total_amount"] as? String)
                (cell?.viewWithTag(24) as! UILabel).text = (self.dataSource?["current_active_total"] as? NSNumber)?.stringValue
                (cell?.viewWithTag(25) as! UILabel).text = (self.dataSource?["current_freeze_total"] as? NSNumber)?.stringValue
                (cell?.viewWithTag(26) as! UILabel).text = (self.dataSource?["sell_total_amount"] as? String)
                (cell?.viewWithTag(27) as! UILabel).text = (self.dataSource?["text_level_limitcontent"] as? String)
                
                
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "castCell", for: indexPath)
                let background = cell?.viewWithTag(9)
                background?.layer.borderColor = UIColor.RGB(red: 236.0, green: 235.0, blue: 235.0, alpha: 1.0).cgColor
                background?.layer.borderWidth = 1
                background?.layer.shadowColor = UIColor.black.cgColor
                background?.layer.shadowOffset = CGSize(width: -3, height: 3)
                background?.layer.shadowOpacity = 0.2
                
                (cell?.viewWithTag(1) as! UILabel).text = self.dataSource?["title"] as? String
                (cell?.viewWithTag(11) as! UILabel).text = self.dataSource?["text_reinvest_hold"] as? String
                (cell?.viewWithTag(12) as! UILabel).text = self.dataSource?["text_reinvest_complete"] as? String
                (cell?.viewWithTag(13) as! UILabel).text = self.dataSource?["text_share_price"] as? String
                (cell?.viewWithTag(14) as! UILabel).text = self.dataSource?["text_reinvest_total"] as? String
                (cell?.viewWithTag(21) as! UILabel).text = (self.dataSource?["pending_reinvest"] as? String)
                (cell?.viewWithTag(22) as! UILabel).text = (self.dataSource?["completed_reinvest"] as? NSNumber)?.stringValue
                (cell?.viewWithTag(23) as! UILabel).text = (self.dataSource?["current_share_price"] as? String)
                (cell?.viewWithTag(24) as! UILabel).text = (self.dataSource?["total_reinvest"] as? String)
            }
            
            
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//            if type == StockType.Mine{
                let dic = (self.dataSource?["shares"] as! NSArray)[indexPath.row] as! NSDictionary
                (cell?.viewWithTag(1) as! UILabel).text = dic["date_added"] as? String
                (cell?.viewWithTag(2) as! UILabel).text = dic["deal_name"] as? String
                (cell?.viewWithTag(3) as! UILabel).text = dic["share_price"] as? String//(dic["deal_amount"] as? NSNumber)?.stringValue
                (cell?.viewWithTag(4) as! UILabel).text = dic["status"] as? String
//            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "detailPush", sender: indexPath)
        }
    }
    
    func sellStockBtnDidClick(_ sender:UIButton) -> Void {
        self.performSegue(withIdentifier: "sellPush", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sellPush" {
            let sell = segue.destination as! StockSellViewController
            sell.dataSource = self.dataSource
        }else if segue.identifier == "detailPush" {
            let detail:StockDetailViewController = segue.destination as! StockDetailViewController
            if type == StockType.Mine{
                detail.type = StockDetailType.Stock
            }else{
                detail.type = StockDetailType.Redelivery
            }
            detail.dataSource = self.dataSource
            detail.currentIndexPath = sender as? IndexPath
        }
    }
    
    func requestStock(){
        SVProgressHUD.show()
        var url = "index.php?route=share/my_share&token="  + (UserDefaults.standard.object(forKey: "token") as? String)!
        if self.type == StockType.Cast {
            url = "index.php?route=share/reinvest&token="   + (UserDefaults.standard.object(forKey: "token") as? String)!
        }
        NetworkModel.init(with: [:], url: url, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                SVProgressHUD.dismiss()
                self.dataSource = dic
                self.tableView.reloadData()
                self.searchBar?.placeholder = dic["text_search"] as? String
                
                if self.dataSource != nil && (self.dataSource?["shares"] as! NSArray).count > 20 {
                    self.footerView.isHidden = false
                }else{
                    self.footerView.isHidden = true
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
