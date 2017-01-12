//
//  MoneyListViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class MoneyListViewControler: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var pageBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    
    var page = 1
    var dataSource:NSDictionary?
    var keys:[String]?
    
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
        
        self.pageBtn.layer.cornerRadius = 4
        
        self.requestChange()
        
    }
    
    //MARK:- UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource == nil{
            return 0
        }
        return (self.keys?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?["text_log_title"] as? String
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let key = self.keys![indexPath.row] 
        let dic = (self.dataSource?["bonus"] as! NSDictionary)[key] as! NSDictionary
        (cell.viewWithTag(1) as! UILabel).text = dic["date_added"] as? String
        (cell.viewWithTag(2) as! UILabel).text = dic["from_name"] as? String
        (cell.viewWithTag(4) as! UILabel).text = dic["text_bonus_front"] as! String + (dic["text_bonus"] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "detailPush", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPush" {
            
        }
    }
    
    func requestChange() -> Void {
        SVProgressHUD.show()
        NetworkModel.init(with: [:], url: "index.php?route=finance/change_log&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                self.dataSource = dic
                self.keys = (self.dataSource?["bonus"] as? NSDictionary)?.allKeys as? [String]
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                self.title = dic["text_log_title"] as? String
                
                if self.dataSource != nil && (self.keys?.count)! > 20 {
                    self.footerView.isHidden = false
                }else{
                    self.footerView.isHidden = true
                }
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure: { (request) in
            
        })
    }
    
}
