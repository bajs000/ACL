//
//  RankListAlert.swift
//  ACL
//
//  Created by YunTu on 2016/12/23.
//  Copyright © 2016年 work. All rights reserved.
//

import UIKit

class RankListAlert: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    var rankList:[String]?
    var completeSelectRank:((String) -> Void)?
    
    func show(_ rankList:[String],complete:((String) -> Void)?) -> Void {
        self.rankList = rankList
        self.tableView.reloadData()
        self.completeSelectRank = complete
        
        let window:UIWindow = ((UIApplication.shared.delegate?.window)!)! as UIWindow
        self.frame = window.frame
        window.addSubview(self)
        window.bringSubview(toFront: self)
        var height:Int = (self.rankList?.count)!
        height = height * 55
        self.tableViewHeight.constant = CGFloat(height)
        self.layoutIfNeeded()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.isScrollEnabled = false
        self.tableView.layer.cornerRadius = 4
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: ({
            self.tableView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }), completion: {(_ finish:Bool) -> Void in
            UIView.animate(withDuration: 0.23, delay: 0, options: .curveEaseInOut, animations: ({
                self.tableView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }), completion: {(_ finish:Bool) -> Void in
                UIView.animate(withDuration: 0.09, delay: 0.02, options: .curveEaseInOut, animations: ({
                    self.tableView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }), completion: {(_ finish:Bool) -> Void in
                    UIView.animate(withDuration: 0.05, delay: 0.02, options: .curveEaseInOut, animations: ({
                        self.tableView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }), completion: {(_ finish:Bool) -> Void in
                        
                    })
                })
            })
        })
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.rankList == nil {
            return 0
        }
        return (self.rankList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? RankCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("RankListAlert", owner: nil, options: nil)?[1] as? RankCell
        }
        if indexPath.row == (self.rankList?.count)! - 1 {
            cell?.cancelLabel.isHidden = false
            cell?.rankLabel.isHidden = true
            cell?.cancelLabel.text = rankList?[indexPath.row]
        }else{
            cell?.cancelLabel.isHidden = true
            cell?.rankLabel.isHidden = false
            cell?.rankLabel.text = rankList?[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == (self.rankList?.count)! - 1 {
            
        }else if indexPath.row == 0{
            return
        }else{
            self.completeSelectRank!((self.rankList?[indexPath.row])!)
        }
        
        self.removeFromSuperview()
    }

}



class RankCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    
}
