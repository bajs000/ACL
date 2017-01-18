//
//  MoneyChangeViewControler.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class MoneyChangeViewControler: UITableViewController {
    
    var dataSource:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.title = "日志详情"
        self.requestChange()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let background = cell.viewWithTag(2)
        background?.layer.borderColor = UIColor.RGB(red: 236.0, green: 235.0, blue: 235.0, alpha: 1.0).cgColor
        background?.layer.borderWidth = 1
        background?.layer.shadowColor = UIColor.black.cgColor
        background?.layer.shadowOffset = CGSize(width: 2, height: 2)
        background?.layer.shadowOpacity = 0.2
        return cell
    }
    
    func requestChange() -> Void {
        SVProgressHUD.show()
        NetworkModel.init(with: [:], url: "", requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            print(request.responseObject ?? [])
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                self.dataSource = dic
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure: { (request) in
            SVProgressHUD.dismiss()
        })
    }
    
}
