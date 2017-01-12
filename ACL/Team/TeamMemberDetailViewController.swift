//
//  TeamMemberDetailViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit

class TeamMemberDetailViewController: UITableViewController {
    
    var dataSource:NSDictionary?
    var currentIndexPath:IndexPath?
    var type:TeamType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员详情"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        if self.dataSource != nil {
            self.title = self.dataSource?["text_table_detail"] as? String
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource == nil {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let dic = (self.dataSource?["nodes"] as! NSArray)[(self.currentIndexPath?.row)!] as! NSDictionary
        if type == TeamType.All{
            (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_team_name"] as! String + "："
            (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_team_rank"] as! String + "："
            (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_team_date"] as! String + "："
            (cell.viewWithTag(14) as! UILabel).text = self.dataSource?["text_team_referal"] as! String + "："
            (cell.viewWithTag(15) as! UILabel).text = self.dataSource?["text_team_leader"] as! String + "："
            (cell.viewWithTag(16) as! UILabel).text = self.dataSource?["text_team_location"] as! String + "："
            (cell.viewWithTag(17) as! UILabel).text = self.dataSource?["text_team_left"] as! String + "："
            (cell.viewWithTag(18) as! UILabel).text = self.dataSource?["text_team_right"] as! String + "："
            
            (cell.viewWithTag(21) as! UILabel).text = (dic["customer_name"] as? String)
            (cell.viewWithTag(22) as! UILabel).text = (dic["rank"] as? String)
            (cell.viewWithTag(23) as! UILabel).text = (dic["date_added"] as? String)
            (cell.viewWithTag(24) as! UILabel).text = (dic["recommended_name"] as? String)
            (cell.viewWithTag(25) as! UILabel).text = (dic["parent_name"] as? String)
            (cell.viewWithTag(26) as! UILabel).text = (dic["position"] as? String)
            (cell.viewWithTag(27) as! UILabel).text = (dic["l_total"] as? String)
            (cell.viewWithTag(28) as! UILabel).text = (dic["r_total"] as? String)
        }else{
            (cell.viewWithTag(11) as! UILabel).text = self.dataSource?["text_member_name"] as! String + "："
            (cell.viewWithTag(12) as! UILabel).text = self.dataSource?["text_member_rank"] as! String + "："
            (cell.viewWithTag(13) as! UILabel).text = self.dataSource?["text_member_date"] as! String + "："
            (cell.viewWithTag(14) as! UILabel).text = self.dataSource?["text_member_referal"] as! String + "："
            (cell.viewWithTag(15) as! UILabel).text = self.dataSource?["text_member_leader"] as! String + "："
            (cell.viewWithTag(16) as! UILabel).text = self.dataSource?["text_member_location"] as! String + "："
            (cell.viewWithTag(17) as! UILabel).text = self.dataSource?["text_member_left"] as! String + "："
            (cell.viewWithTag(18) as! UILabel).text = self.dataSource?["text_member_right"] as! String + "："
            
            (cell.viewWithTag(21) as! UILabel).text = (dic["customer_name"] as? String)
            (cell.viewWithTag(22) as! UILabel).text = (dic["rank"] as? String)
            (cell.viewWithTag(23) as! UILabel).text = (dic["date_added"] as? String)
            (cell.viewWithTag(24) as! UILabel).text = (dic["recommended_name"] as? String)
            (cell.viewWithTag(25) as! UILabel).text = (dic["parent_name"] as? String)
            (cell.viewWithTag(26) as! UILabel).text = (dic["position"] as? String)
            (cell.viewWithTag(27) as! UILabel).text = (dic["l_total"] as? String)
            (cell.viewWithTag(28) as! UILabel).text = (dic["r_total"] as? String)
        }
        
        
        let background = cell.viewWithTag(2)
        background?.layer.borderColor = UIColor.RGB(red: 236.0, green: 235.0, blue: 235.0, alpha: 1.0).cgColor
        background?.layer.borderWidth = 1
        background?.layer.shadowColor = UIColor.black.cgColor
        background?.layer.shadowOffset = CGSize(width: 2, height: 2)
        background?.layer.shadowOpacity = 0.2
        return cell
    }
    
}
