//
//  USCell.swift
//  ACL
//
//  Created by YunTu on 2016/12/26.
//  Copyright © 2016年 work. All rights reserved.
//

import UIKit

class USCell: UITableViewCell {

    @IBOutlet weak var button1Height: NSLayoutConstraint!
    @IBOutlet weak var button1Top: NSLayoutConstraint!
    @IBOutlet weak var button2Height: NSLayoutConstraint!
    @IBOutlet weak var button2Top: NSLayoutConstraint!
    @IBOutlet weak var button3Height: NSLayoutConstraint!
    @IBOutlet weak var button3Top: NSLayoutConstraint!
    @IBOutlet weak var button4height: NSLayoutConstraint!
    @IBOutlet weak var button4Top: NSLayoutConstraint!
    @IBOutlet weak var shadowViewBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
