//
//  AbortViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class AbortViewController: UITableViewController {
    
    @IBOutlet weak var aclFeature: UILabel!
    @IBOutlet weak var aclVision: UILabel!
    var dataSource:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于ACL"
        self.requestAbort()
//        let tabbar = self.tabBarController as! ACLTabBarViewController
//        if tabbar.languageDic != nil {
//            self.aclFeature.text = tabbar.languageDic?["text_features"] as? String
//            self.aclVision.text = tabbar.languageDic?["text_about"] as? String
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let feature:ACLFeatureViewController = segue.destination as! ACLFeatureViewController
        if segue.identifier == "featurePush" {
            feature.type = AbortType.Feature
        }else{
            feature.type = AbortType.Vision
        }
        feature.dataSource = self.dataSource
    }
    
    func requestAbort() -> Void {
        SVProgressHUD.show()
        let req = URLRequest(url: URL(string: "https://www.usacl.com/app/v1/index.php?route=information/about&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!)!)
        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue(), completionHandler: {(_ response:URLResponse?, data:Data?, error:Error?) -> Void in
            if error == nil {
                do{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    if Int(dic["login"] as! String) == 1 {
                        DispatchQueue.main.async(execute: {
                            SVProgressHUD.dismiss()
                            self.dataSource = dic
                            self.aclFeature.text = dic["text_features"] as? String
                            self.aclVision.text = dic["text_about"] as? String
                            self.title = dic["text_about"] as? String
                        })
                        
                    }else{
                        DispatchQueue.main.async(execute: {
                        self.dismiss(animated: true, completion: nil)
                            SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
                        })
                    }
                }catch{
                    DispatchQueue.main.async(execute: {
                        SVProgressHUD.dismiss()
                    })
                }
            }else{
                DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                    print(error!)
                })
            }
        })
    }
    
}
