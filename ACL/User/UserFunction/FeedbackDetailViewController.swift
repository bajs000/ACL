//
//  FeedbackDetailViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class FeedbackDetailViewController : UITableViewController {
    
    var dataSource:NSDictionary?
    var currentIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.title = self.dataSource?["text_feedback_detail"] as? String
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let background = cell.viewWithTag(2)
        background?.layer.borderColor = UIColor.RGB(red: 236.0, green: 235.0, blue: 235.0, alpha: 1.0).cgColor
        background?.layer.borderWidth = 1
        background?.layer.shadowColor = UIColor.black.cgColor
        background?.layer.shadowOffset = CGSize(width: 2, height: 2)
        background?.layer.shadowOpacity = 0.2
        let dic = (self.dataSource?["feedbacks"] as! NSArray)[self.currentIndexPath!.row] as! NSDictionary
        (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_feedback_id"] as! String + ":"
        (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_feedback_date"] as! String + ":"
        (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_feedback_title"] as! String + ":"
        (cell.viewWithTag(14) as! UILabel).text = self.dataSource?["text_feedback_content"] as! String + ":"
        (cell.viewWithTag(15) as! UILabel).text = self.dataSource?["text_feedback_id"] as! String + ":"
        
        (cell.viewWithTag(21) as! UILabel).text = (dic["feedback_id"] as? String)
        (cell.viewWithTag(22) as! UILabel).text = (dic["date_added"] as? String)
        (cell.viewWithTag(23) as! UILabel).text = (dic["title"] as? String)
        (cell.viewWithTag(24) as! UILabel).text = (dic["text"] as? String)
        (cell.viewWithTag(25) as! UILabel).text = (dic["feedback_id"] as? String)
        
        return cell
    }
    
}
