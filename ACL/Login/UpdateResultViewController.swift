//
//  UpdateResultViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/28.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit

class UpdateResultViewController: UIViewController {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    var languageDic:NSDictionary?
    
    @IBAction func loginBtnDidClick(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.cornerRadius = 4
        
        if languageDic != nil {
            self.alertLabel.text = self.languageDic?["text_sucess"] as? String
            self.loginBtn.setTitle((self.languageDic?["text_login"] as? String)! + ">", for: .normal)
        }
    }
    
}
