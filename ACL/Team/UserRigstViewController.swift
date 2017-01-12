//
//  UserRigstViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/2.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class UserRigstViewController: RegistViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var protcolBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    var recommandText:UITextField?
    var leaderText:UITextField?
    var rankText:UITextField?
    var userName:UITextField?
    var phoneText:UITextField?
    var listArr:[NSDictionary]?
    var currentRank:String?
    
    override var dataSource: NSDictionary?{
        didSet{
            if self.dataSource != nil{
                listArr = [["title":self.dataSource?["text_member_referal"] as! String,"detail":self.dataSource?["text_register_referraltip"] as! String,"registCoin":self.dataSource?["text_member_referal"] as! String,"alert":""],
                           ["title":self.dataSource?["text_member_leader"] as! String,"detail":""],
                           ["title":self.dataSource?["text_member_rank"] as! String,"detail":self.dataSource?["text_rank0"] as! String],
                           ["title":self.dataSource?["text_member_name"] as! String,"detail":self.dataSource?["text_nicknameplaceholder"] as! String],
                           ["title":self.dataSource?["text_member_phone"] as! String,"detail":self.dataSource?["text_phone_reason"] as! String]]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShow(_ notification:Notification) -> Void {
        let keyboardRect:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.tableViewBottom.constant = -keyboardRect.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(_ notification:Notification) -> Void {
        UIView.animate(withDuration: 0.75, animations: ({
            self.tableViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }), completion: {(_ finish:Bool) -> Void in
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.commitBtn.layer.cornerRadius = 6
        self.protcolBtn.setTitle(self.dataSource?["text_agreement"] as? String, for: .normal)
        self.commitBtn.setTitle(self.dataSource?["text_member_register"] as? String, for: .normal)
    }
    
    public class func getInstance() -> UserRigstViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:UserRigstViewController = storyboard.instantiateViewController(withIdentifier: "userRegist") as! UserRigstViewController
        return vc
    }
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.listArr == nil {
            return 0
        }
        return (listArr?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        let dic = listArr?[indexPath.row]
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "recommandCell", for: indexPath)
            (cell?.viewWithTag(1) as! UILabel).text = dic?["registCoin"] as? String
            (cell?.viewWithTag(2) as! UILabel).text = dic?["title"] as? String
            (cell?.viewWithTag(3) as! UITextField).placeholder = dic?["detail"] as? String
            recommandText = cell?.viewWithTag(3) as? UITextField
//            (cell?.viewWithTag(4) as! UILabel).text = dic?["alert"] as? String
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            (cell?.viewWithTag(1) as! UILabel).text = dic?["title"] as? String
            (cell?.viewWithTag(2) as! UITextField).placeholder = dic?["detail"] as? String
            if indexPath.row == 2 {
                (cell?.viewWithTag(2) as! UITextField).isEnabled = false
                if self.currentRank != nil {
                    (cell?.viewWithTag(2) as! UITextField).text = self.currentRank
                }
            }else{
                (cell?.viewWithTag(2) as! UITextField).isEnabled = true
            }
            switch indexPath.row {
            case 1:
                leaderText = cell?.viewWithTag(2) as? UITextField
                break
            case 2:
                rankText = cell?.viewWithTag(2) as? UITextField
                break
            case 3:
                userName = cell?.viewWithTag(2) as? UITextField
                break
            case 4:
                phoneText = cell?.viewWithTag(2) as? UITextField
                break
            default:
                break
            }
            
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let alert = Bundle.main.loadNibNamed("RankListAlert", owner: nil, options: nil)?[0] as! RankListAlert
            var arr:[String] = []
            for i in 0...10 {
                if i == 0 {
                    arr.append(self.dataSource?["text_rank0"] as! String)
                }else{
                    if self.dataSource?["text_rank" + String(i)] == nil {
                        arr.append(self.dataSource?["text_member_close"] as! String)
                        break
                    }else{
                        arr.append(self.dataSource?["text_rank" + String(i)] as! String)
                    }
                }
            }
            alert.show(arr, complete: { (str) in
                self.currentRank = str
                self.tableView.reloadData()
            })
        }
    }
    
    func requestRegist() -> Void {
        SVProgressHUD.show()
//        let req = URLRequest(url: URL(string:"https://www.usacl.com/app/v1/index.php?route=team/register&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!)!)
        
        var req = URLRequest(url: URL(string:"https://www.usacl.com/app/v1/index.php?route=team/register&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!)!)
        req.httpMethod = "POST"
        let bodyStr = "recommended_name=" + (self.recommandText?.text)! + "&nickname=" + (self.userName?.text)! + "&rank=" + (self.rankText?.text)! + "&phone=" + (self.phoneText?.text)! + "&tree_id=" + ""
        let bodyData = bodyStr.data(using: .utf8)
        req.httpBody = bodyData
        
        NSURLConnection.sendAsynchronousRequest(req as URLRequest, queue: OperationQueue(), completionHandler: {(_ response:URLResponse?, data:Data?, error:Error?) -> Void in
            SVProgressHUD.dismiss()
            if error == nil {
                do{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    if Int(dic["login"] as! String) == 1 {
                        
                    }else{
                        self.dismiss(animated: true, completion: nil)
                        SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
                    }
                }catch{
                    
                }
            }else{
                print(error!)
            }
        })
    }
    
}
