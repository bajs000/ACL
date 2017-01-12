//
//  AlertCell.swift
//  ACL
//
//  Created by YunTu on 2016/12/26.
//  Copyright © 2016年 work. All rights reserved.
//

import UIKit

class AlertCell: UITableViewCell {

    @IBOutlet weak var firstTop: NSLayoutConstraint!
    @IBOutlet weak var secondTop: NSLayoutConstraint!
    var alertList:[String]?{
        didSet{
            self.firstLabel.text = self.alertList?[0]
            let time = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(repeatLabel), userInfo: nil, repeats: true)
            RunLoop.current.add(time, forMode: .commonModes)
        }
    }
    var count = 0
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func repeatLabel() {
        if self.count + 1 == self.alertList?.count {
            self.count = 0
        }else{
            self.count = self.count + 1
        }
        if self.firstTop.constant == 0 {
            self.secondLabel.text = self.alertList?[self.count]
        }else{
            self.firstLabel.text = self.alertList?[self.count]
        }
        UIView.animate(withDuration: 0.5, animations: ({
            if self.firstTop.constant == 0 {
                self.firstTop.constant = -41
                self.secondTop.constant = 0
            }else{
                self.firstTop.constant = 0
                self.secondTop.constant = -41
            }
            self.layoutIfNeeded()
        }), completion: {(_ finish:Bool) -> Void in
            if self.firstTop.constant == 0 {
                self.secondTop.constant = 41
            }else{
                self.firstTop.constant = 41
            }
            self.layoutIfNeeded()
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
