//
//  MainViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/29.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

enum ChartType:Int {
    case aquae = 10
    case pie   = 20
}

class MainViewController: UITableViewController, UIWebViewDelegate {
    
    var isShowQueueCell:Bool = true
    var languageDic:NSDictionary?
    var html1:String?
    var html2:String?
    var totalHeight:CGFloat = 0.0
    var noticeStr:String?
    var alertDic:NSDictionary?
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var aquaeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pieViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sysInfoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var aquareWeb: UIWebView!
    @IBOutlet weak var pieWeb: UIWebView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var aquareLabel: UILabel!
    @IBOutlet weak var pieLabel: UILabel!
    @IBOutlet weak var noticeTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barInit()
        
        let titleImg = UIImageView.init(image: UIImage(named: "main-title"))
        self.navigationItem.titleView = titleImg
        
        let rightBar = UIView.init(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -16
        self.navigationItem.rightBarButtonItems = [negativeSpacer,UIBarButtonItem.init(customView: rightBar)]
        
        let moneyBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        moneyBtn.setImage(UIImage(named: "main-right-0"), for: .normal)
        let personBtn = UIButton.init(frame: CGRect(x: moneyBtn.frame.size.width, y: 0, width: moneyBtn.frame.size.width, height: 44))
        personBtn.setImage(UIImage(named: "main-right-1"), for: .normal)
        moneyBtn.addTarget(self, action: #selector(moneyBtnDidClick(_:)), for: .touchUpInside)
        personBtn.addTarget(self, action: #selector(personBtnDidClick(_:)), for: .touchUpInside)
        rightBar.addSubview(moneyBtn)
        rightBar.addSubview(personBtn)
        
        self.requestLanguage()
        self.requestRobMoney(nil)
    }
    
    //MARK:- UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if isShowQueueCell{
                return 41
            }else{
                return 0
            }
        }else if indexPath.row == 1 {
            return 346
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath)
            let btn = cell?.viewWithTag(1) as! UIButton
            btn.addTarget(self, action: #selector(dismissQueueCell(_:)), for: .touchUpInside)
            btn.setImage(btn.currentImage?.withColor(UIColor(red: 153, green: 153, blue: 153, alpha: 1)), for: .normal)
//            (cell?.viewWithTag(2) as! UILabel).text = self.languageDic?["text_status_cashcoin"] as? String
            
            if self.languageDic != nil {
                var alertList = [String]()
                if self.languageDic?["in_listing_overtime"] != nil && (self.languageDic?["in_listing_overtime"] as! String).characters.count > 0{
                    alertList.append(self.languageDic?["in_listing_overtime"] as! String)
                }
                if self.languageDic?["in_buy_listing"] != nil && (self.languageDic?["in_buy_listing"] as! String).characters.count > 0{
                    alertList.append(self.languageDic?["in_buy_listing"] as! String)
                }
                if self.languageDic?["unpaid_order"] != nil && (self.languageDic?["unpaid_order"] as! String).characters.count > 0{
                    alertList.append(self.languageDic?["unpaid_order"] as! String)
                }
                if self.languageDic?["unconfirm_order"] != nil && (self.languageDic?["unconfirm_order"] as! String).characters.count > 0{
                    alertList.append(self.languageDic?["unconfirm_order"] as! String)
                }
                if self.languageDic?["unread_feedback"] != nil && (self.languageDic?["unread_feedback"] as! String).characters.count > 0{
                    alertList.append(self.languageDic?["unread_feedback"] as! String)
                }
                (cell as! AlertCell).alertList = alertList
            }
        }else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "controlCell", for: indexPath)
            for i in 1...4 {
                let btn = cell?.viewWithTag(i)
                btn?.layer.cornerRadius = 4
                let titleLabel = cell?.viewWithTag((btn?.tag)! * 10 + 1) as! UILabel
                titleLabel.text = self.languageDic?["text_static" + String(i)] as? String
                var detail:UILabel?
                switch i {
                case 1:
                    detail = cell?.viewWithTag((btn?.tag)! * 10 + 2) as? UILabel
                    detail?.text = self.languageDic?["share_total_num"] as? String
                    break
                case 2:
                    detail = cell?.viewWithTag((btn?.tag)! * 10 + 2) as? UILabel
                    detail?.text = self.languageDic?["activation_coin"] as? String
                    break
                case 3:
                    detail = cell?.viewWithTag((btn?.tag)! * 10 + 2) as? UILabel
                    detail?.text = self.languageDic?["cash_coin"] as? String
                    break
                case 4:
                    detail = cell?.viewWithTag((btn?.tag)! * 10 + 2) as? UILabel
                    detail?.text = self.languageDic?["rewards_total"] as? String
                    break
                default:
                    break
                }
                //                titleLabel = cell?.viewWithTag((btn?.tag)! * 10 + 2) as! UILabel
                //                titleLabel.text = self.languageDic?["text_static1"] as? String
            }
            
        }
        return cell!
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        DispatchQueue.once(token: "pie", block: {
            self.requestWebHtml(.pie)
        })
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        if webView.tag == self.aquareWeb.tag + 20 {
            if webView.scrollView.contentSize.height == 1 {
                self.requestWebHtml(.aquae)
                return
            }
            totalHeight = totalHeight + webView.scrollView.contentSize.height + 68 + 49
            self.aquaeViewHeight.constant = webView.scrollView.contentSize.height + 68 + 49
            self.aquareWeb.loadHTMLString(self.html1!, baseURL: nil)
        }else if webView.tag == self.pieWeb.tag + 20{
            self.pieViewHeight.constant = min(webView.scrollView.contentSize.height, 340) + 68 + 49
            self.pieWeb.loadHTMLString(self.html2!, baseURL: nil)
            totalHeight = totalHeight + min(webView.scrollView.contentSize.height, 340) + 68 + 49
        }else{
            return
        }
        
        self.footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: totalHeight + 8 + self.sysInfoViewHeight.constant)
        self.tableView.beginUpdates()
        self.tableView.tableFooterView = self.footerView
        self.tableView.endUpdates()
        
        
        print(webView.scrollView.contentSize.height)
        print(webView.sizeThatFits(.zero))
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
        SVProgressHUD.dismiss()
    }
    
    func barInit() -> Void {
        var i:Int = 0
        var titleArr = ["桌面","股份","团队","财务","我的"]
        let tabbar = self.tabBarController as! ACLTabBarViewController
        if tabbar.languageDic != nil && tabbar.languageDic?["menu"] != nil{
            titleArr = ((tabbar.languageDic?["menu"] as! NSDictionary)[UserDefaults.standard.object(forKey: "language") as! String] as! NSArray) as! [String]
        }
        for item in (self.tabBarController?.tabBar.items)! {
            let normalImg = UIImage(named: "main-bar-" + String(i))
            let selectImg = UIImage(named: "main-bar-selected-" + String(i))
            item.selectedImage = selectImg
            item.image = normalImg
            item.title = titleArr[i]
            item .setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1)], for: .selected)
            item .setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)], for: .normal)
            i = i + 1
        }
    }
    
    //MARK:- UIButton Action
    func moneyBtnDidClick(_ sender:UIButton) -> Void {
        
        let alert = Bundle.main.loadNibNamed("CustomAlertView", owner: nil, options: nil)?[0] as! CustomAlertView
        if self.alertDic != nil {
            alert.showMoney(title: (self.alertDic?["text_header_beginbuy"] as! String),
                            moneyTitle: (self.alertDic?["text_header_buystatus"] as! String),
                            detail: Helpers.optimizeString(self.alertDic?["text_header_buynote"] as! String),
                            sureTitle: self.alertDic?["text_header_submit"] as! String,
                            cancelTitle: self.alertDic?["text_header_close"] as! String,
                            block: {(_ sender:UIButton?) -> Void in
//                                print(sender!)
                                if (alert.textField.text?.characters.count)! > 0 {
                                    self.requestRobMoney(alert.textField.text!)
                                }
                                
            })
        }
//        print("money")
    }
    
    func personBtnDidClick(_ sender:UIButton) -> Void {
        _ = self.navigationController?.pushViewController(TeamPageViewController.getInstance(), animated: true)
//        let alert = Bundle.main.loadNibNamed("CustomAlertView", owner: nil, options: nil)?[1] as! CustomAlertView
//        if self.languageDic != nil{
//            alert.showNotice(title: (self.languageDic?["text_bulletin_title"] as? String)!, detail: (Helpers.optimizeString((self.languageDic?["text_bulletin_content"] as? String)!)))
//        }else{
//            alert.showNotice(title: "系统公告", detail: "说明：您在选择要买入现金币额度并提交之后，系统会随机为您匹配到出售现金币的会员，您作为买方要支付匹配金额的人民币金，享受10%说明：您在选择要买入现金币额度并提交之后，系统会随机为您匹配到出售现金币的会员，您作为买方要支付匹配金额的人民币金，享受10%")        }
//        print("person")
    }
    
    func dismissQueueCell(_ sender:UIButton) -> Void {
        isShowQueueCell = !isShowQueueCell
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func requestLanguage() {
        if UserDefaults.standard.object(forKey: "token") as? String != nil{
            SVProgressHUD.show()
            NetworkModel.init(with: [:], url: "index.php?route=common/dashboard&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (YTKBaseRequest) in
                let dic:NSDictionary = YTKBaseRequest.responseObject as! NSDictionary
                if Int(dic["login"] as! String) == 1 {
                    self.languageDic = dic
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    self.totalHeight = 0
                    self.requestWebHtml(.aquae)
                    self.noticeStr = Helpers.optimizeString((dic["text_bulletin_content"] as? String)!)
                    self.aquareLabel.text = dic["text_chart_title"] as? String
                    self.pieLabel.text = dic["text_cake_title"] as? String
                    self.noticeTitle.text = dic["text_bulletin_title"] as? String
                    if self.noticeStr != nil {
                        let size = (self.noticeStr! as NSString).boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 32, height: 999999), options: [.usesLineFragmentOrigin , .usesFontLeading , .truncatesLastVisibleLine], attributes: [NSFontAttributeName:self.noticeTitle.font], context: nil).size
                        self.sysInfoViewHeight.constant = (size.height + 58)
                        self.view.layoutIfNeeded()
                        self.noticeLabel.text = self.noticeStr
                    }
                    
                    (self.footerView.viewWithTag(51) as! UILabel).text = self.languageDic?["split_times"] as? String
                    (self.footerView.viewWithTag(52) as! UILabel).text = self.languageDic?["text_split_times"] as? String
                    (self.footerView.viewWithTag(53) as! UILabel).text = self.languageDic?["current_share_price"] as? String
                    (self.footerView.viewWithTag(54) as! UILabel).text = self.languageDic?["text_chart_block2"] as? String
                    (self.footerView.viewWithTag(55) as! UILabel).text = self.languageDic?["split_num"] as? String
                    (self.footerView.viewWithTag(56) as! UILabel).text = self.languageDic?["text_chart_block3"] as? String
                    
                    (self.footerView.viewWithTag(61) as! UILabel).text = self.languageDic?["recommended_bonus"] as? String
                    (self.footerView.viewWithTag(62) as! UILabel).text = self.languageDic?["text_cake_block1"] as? String
                    (self.footerView.viewWithTag(63) as! UILabel).text = self.languageDic?["leader_bonus"] as? String
                    (self.footerView.viewWithTag(64) as! UILabel).text = self.languageDic?["text_cake_block2"] as? String
                    (self.footerView.viewWithTag(65) as! UILabel).text = self.languageDic?["collision_bonus"] as? String
                    (self.footerView.viewWithTag(66) as! UILabel).text = self.languageDic?["text_cake_block3"] as? String
                    (self.footerView.viewWithTag(67) as! UILabel).text = self.languageDic?["point_bonus"] as? String
                    (self.footerView.viewWithTag(68) as! UILabel).text = self.languageDic?["text_cake_block4"] as? String
                    
                    
                }else{
                    self.dismiss(animated: true, completion: nil)
                    SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
                }
            }, failure: {(YTKBaseRequest) in
                print(YTKBaseRequest.error!)
                SVProgressHUD.dismiss()
            })
        }
    }
    
    func requestWebHtml(_ type:ChartType) -> Void {
        SVProgressHUD.show()
        if self.tableView.viewWithTag(type.rawValue + 20) != nil {
            self.tableView.viewWithTag(type.rawValue + 20)?.removeFromSuperview()
        }
        let req = URLRequest(url: URL(string: "https://www.usacl.com/app/v1" + "/index.php?route=common/price_chart&token=" + (UserDefaults.standard.object(forKey: "token") as? String)! + "&show_chart=" + String(type.rawValue / 10))!)
        let web = UIWebView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height * 10, width: UIScreen.main.bounds.size.width, height: 1))
        web.tag = type.rawValue + 20
        self.tableView.addSubview(web)
        web.delegate = self

        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue(), completionHandler: {(response:URLResponse?, data:Data?, error:Error?) -> Void in
            if error == nil {
                let str = String(data: data!, encoding: .utf8)
                if type.rawValue == 10 {
                    self.html1 = str
                    web.loadHTMLString(self.html1!, baseURL: nil)
                }else{
                    self.html2 = str
                    web.loadHTMLString(self.html2!, baseURL: nil)
                }
                
            }else{
                print(error!)
            }
        })
    }
    
    func requestRobMoney(_ value:String?) {
        if value != nil {
            SVProgressHUD.show()
        }
        var req = URLRequest(url: URL(string: "https://www.usacl.com/app/v1/index.php?route=finance/coin/changeBuyList&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!)!)
        if value != nil {
            req.httpMethod = "POST"
            let bodyStr = "buy_coin_value=" + value!
            let bodyData = bodyStr.data(using: .utf8)
            req.httpBody = bodyData
        }
        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue(), completionHandler: {(response:URLResponse?, data:Data?, error:Error?) -> Void in
            if error == nil {
                do{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    self.alertDic = dic
                    if value != nil {
                        SVProgressHUD.dismiss()
                    }
                    if dic["success"] != nil {
                    
                    }else if dic["error"] != nil && value != nil{
                        SVProgressHUD.showError(withStatus: dic["error"] as! String)
                    }
                }catch{
                
                }
            }else{
                print(error!)
            }
        })
    }
}
