//
//  TeamMemberViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

enum TeamType {
    case All
    case Mine
}

class TeamMemberViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var pageBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    
    var dataSource:NSDictionary?
    var page = 1
    var type:TeamType?
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
        searchBar?.placeholder = "在此搜索用户名."
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
        
        
        
        self.requestAllMember(nil)
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
        self.requestAllMember(searchBar.text)
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
        self.requestAllMember(searchBar.text)
        searchBar.text = ""
    }
    
    //MARK:- UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource == nil {
            return 0
        }
        return (self.dataSource?["nodes"] as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if dataSource != nil{
            var key = "text_member_amount"
            if type == TeamType.All {
                key = "text_team_amount"
            }
            (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?[key] as! String + (self.dataSource?["total_num"] as! String)
        }
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = (self.dataSource?["nodes"] as! NSArray)[indexPath.row] as! NSDictionary
        (cell.viewWithTag(1) as! UILabel).text = dic["date_added"] as? String
        (cell.viewWithTag(2) as! UILabel).text = dic["customer_name"] as? String
//        var key = "text_member_star"
//        if self.type == TeamType.All {
//            key = "text_team_star"
//        }
        (cell.viewWithTag(3) as! UILabel).text = dic["rank"] as? String// + (self.dataSource?[key] as! String)
        (cell.viewWithTag(4) as! UILabel).text = dic["level"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailPush", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "detailPush" {
            let detail = segue.destination as! TeamMemberDetailViewController
            detail.dataSource = self.dataSource
            detail.currentIndexPath = sender as? IndexPath
            detail.type = self.type
        }
    }
    
    func requestAllMember(_ searchText:String?) {
        SVProgressHUD.show()
        var dic:NSDictionary = [:]
        if searchText != nil && (searchText?.characters.count)! > 0{
            dic = ["search_name":searchText!]
        }
        var url = "index.php?route=team/my_member&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!
        if self.type == TeamType.All {
            url = "index.php?route=team/my_team&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!
        }
        NetworkModel.init(with: dic, url: url, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                SVProgressHUD.dismiss()
                self.dataSource = dic
                self.tableView.reloadData()
                var key1 = "text_member_previous"
                var key2 = "text_member_next"
                if self.type == TeamType.All {
                    key1 = "text_team_previous"
                    key2 = "text_team_next"
                }
                self.previousBtn.setTitle((self.dataSource?[key1] as? String)!, for: .normal)
                self.nextBtn.setTitle((self.dataSource?[key2] as? String)!, for: .normal)
                self.searchBar?.placeholder = self.dataSource?["text_search"] as? String
                
                if self.dataSource != nil && (self.dataSource?["nodes"] as! NSArray).count > 20 {
                    self.footerView.isHidden = false
                }else{
                    self.footerView.isHidden = true
                }
                
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure: { (request) in
            print(request.error!)
            SVProgressHUD.dismiss()
        })
    }
    
}
