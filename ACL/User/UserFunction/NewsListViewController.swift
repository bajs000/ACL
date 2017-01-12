//
//  NewsListViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import AFNetworking
import YTKNetwork

class NewsListViewControler: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        self.pageBtn.layer.cornerRadius = 4
        
//        self.title = "新闻"
        
        self.requestNews()
        
    }
    
    //MARK:- UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource == nil{
            return 0
        }
        return (self.dataSource?["news"] as! NSArray).count
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 49
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return self.headerView
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = (self.dataSource?["news"] as! NSArray)[indexPath.row] as! NSDictionary
        (cell.viewWithTag(1) as! UILabel).text = dic["title"] as? String
        (cell.viewWithTag(2) as! UILabel).text = dic["date_added"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPush" {
            let detail = segue.destination as! NewsDetailViewController
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let dic = (self.dataSource?["news"] as! NSArray)[(indexPath?.row)!] as! NSDictionary
            detail.contentHtml = dic["text"] as? String
            detail.newsTitle = dic["title"] as? String
        }
    }
    
    func requestNews() {
        SVProgressHUD.show()
        let request = NSURLRequest(url: URL(string: YTKNetworkConfig.shared().baseUrl + "/index.php?route=information/news&token="  + (UserDefaults.standard.object(forKey: "token") as? String)!)!)
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler: {(_ response:URLResponse?, data:Data?, error:Error?) in
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                do {
                    let dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    if Int(dic["login"] as! String) == 1 {
                        self.dataSource = dic
                        self.title = self.dataSource?["text_news_title"] as? String
                        self.tableView.reloadData()
                    
                        if self.dataSource != nil && (self.dataSource?["news"] as! NSArray).count > 20 {
                            self.footerView.isHidden = false
                        }else{
                            self.footerView.isHidden = true
                        }
                    }else{
                        self.dismiss(animated: true, completion: nil)
                        SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
                    }
                }catch{
                    
                }
            })
        })
    }
}
