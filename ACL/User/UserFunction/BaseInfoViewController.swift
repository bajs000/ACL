//
//  BaseInfoViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/1.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class BaseInfoViewController: UITableViewController {
    
    var infoArr:NSArray = []
    var dataSource:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "基本信息"
        self.requestInfo()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = (infoArr[indexPath.row] as! NSDictionary)["title"] as? String
        (cell.viewWithTag(2) as! UITextField).text = (infoArr[indexPath.row] as! NSDictionary)["detail"] as? String
        return cell
    }
    
    func requestInfo(){
        SVProgressHUD.show()
        NetworkModel.init(with: [:], url: "index.php?route=account/profile&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                SVProgressHUD.dismiss()
                self.dataSource = dic
                self.infoArr = [["title":dic["text_profile_name"] as! String,
                                 "detail":dic["customer_name"] as! String],
                                ["title":dic["text_profile_date"] as! String,"detail":dic["date_added"] as! String],
                                ["title":dic["text_profile_rank"] as! String,"detail":NSString(format: "%@", dic["rank"] as! String)],
                                ["title":dic["text_profile_times"] as! String,"detail":NSString(format: "%@", dic["split_times"] as! NSNumber)],
                                ["title":dic["text_profile_wrong"] as! String,"detail":NSString(format: "%@", dic["star"] as! String)],
                                ["title":dic["text_profile_referal"] as! String,"detail":dic["recommended_name"] as! String],
                                ["title":dic["text_profile_leader"] as! String,"detail":dic["parent_name"] as! String],
                                ["title":dic["text_profile_id"] as! String,"detail":dic["id_card_num"] as! String],
                                ["title":dic["text_profile_truename"] as! String,"detail":dic["id_card_name"] as! String],
                                ["title":dic["text_profile_phone"] as! String,"detail":dic["phone"] as! String],
                                ["title":dic["text_profile_email"] as! String,"detail":dic["email"] as! String]]
                
                self.tableView.reloadData()
                self.title = dic["text_profile_title"] as? String
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
