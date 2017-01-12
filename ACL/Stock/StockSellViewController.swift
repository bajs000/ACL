//
//  StockSellViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

class StockSellViewController: UITableViewController {
    
    @IBOutlet weak var stockPriceTextField: UITextField!
    @IBOutlet weak var sellableStockNumTextField: UITextField!
    @IBOutlet weak var sellStockNumTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    var dataSource:NSDictionary?
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        SVProgressHUD.show()
        NetworkModel.init(with: [:], url: "index.php?route=share/my_share/validateSellShare&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            print(request.responseObject ?? "")
        }, failure: { (request) in
            print(request.error!)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.dataSource?["btn_handsell"] as? String
        self.commitBtn.layer.cornerRadius = 6
        self.label1.text = self.dataSource?["text_trade_price"] as? String
        self.stockPriceTextField.text = self.dataSource?["current_share_price"] as? String
        self.label2.text = self.dataSource?["text_sell_sellavailable"] as? String
        self.sellableStockNumTextField.text = (self.dataSource?["current_active_total"] as! NSNumber).stringValue
        self.label3.text = self.dataSource?["text_sell_amount"] as? String
        self.label4.text = self.dataSource?["text_sell_psw"] as? String
        self.label5.text = self.dataSource?["text_sell_autonote"] as? String
        self.commitBtn.setTitle(self.dataSource?["btn_handsell"] as? String, for: .normal)
    }
    
}
