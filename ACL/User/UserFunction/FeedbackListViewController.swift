//
//  FeedbackListViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class FeedbackListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var pageBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    
    var page = 1
    var dataSource:NSDictionary?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestFeedback()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
//        let searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
//        searchBar.showsCancelButton = true
//        searchBar.delegate = self
//        searchBar.placeholder = "在此搜索反馈记录."
//        self.navigationItem.titleView = searchBar
        
        self.pageBtn.layer.cornerRadius = 4
        self.feedbackBtn.layer.cornerRadius = 4
        
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
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
        searchBar.text = ""
    }
    
    //MARK:- UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataSource == nil {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataSource?["feedbacks"] as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        (self.headerView.viewWithTag(1) as! UILabel).text = self.dataSource?["text_feedback_acltitle"] as? String
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = (self.dataSource?["feedbacks"] as! NSArray)[indexPath.row] as! NSDictionary
        (cell.viewWithTag(1) as! UILabel).text = dic["date_added"] as? String
        (cell.viewWithTag(2) as! UILabel).text = dic["title"] as? String
        (cell.viewWithTag(4) as! UILabel).text = dic["status"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailPush", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPush" {
            let list = segue.destination as! FeedbackDetailViewController
            list.currentIndexPath = sender as? IndexPath
            list.dataSource = self.dataSource
        }else if segue.identifier == "feedbackPush" {
            let feedback = segue.destination as! FeedbackViewController
            feedback.dataSource = self.dataSource
        }
    }
    
    func requestFeedback() -> Void {
        SVProgressHUD.show()
        NetworkModel.init(with: [:], url: "index.php?route=information/feedback&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                self.dataSource = dic
                self.title = self.dataSource?["text_feedback_acltitle"] as? String
                self.feedbackBtn.setTitle(self.dataSource?["text_feedback_btnfeedback"] as? String, for: .normal)
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                if self.dataSource != nil && (self.dataSource?["feedbacks"] as! NSArray).count > 20 {
                    self.footerView.isHidden = false
                }else{
                    self.footerView.isHidden = true
                }
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
            SVProgressHUD.dismiss()
        }, failure: { (request) in
            SVProgressHUD.dismiss()
        })
    }
    
}
