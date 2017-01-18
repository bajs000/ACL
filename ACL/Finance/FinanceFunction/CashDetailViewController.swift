//
//  CashDetailViewController.swift
//  ACL
//
//  Created by YunTu on 2017/1/16.
//  Copyright © 2017年 work. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import Masonry

enum CashType {
    case sell
    case buy
}

class CashDetailViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet var imgBg: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var dataSource: NSDictionary?
    var detailInfo: NSDictionary?
    var titleArr: [String:[[String:String]]]?
    var currentIndexPath: IndexPath?
    var currentImg: UIImage?
    var type: CashType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.dataSource?["text_selldetail"] as? String
        var phone = ""
        if self.dataSource?["phone"] != nil {
            phone = dataSource?["phone"] as! String
        }
        
        self.commitBtn.layer.cornerRadius = 8
        
        let dic = (self.dataSource?["bonus_coins"] as! NSArray)[(self.currentIndexPath?.row)!] as! NSDictionary
        if (dic["trade_type"] as? String) == "sell" {
            type = .sell
        }else{
            type = .buy
            self.title = self.dataSource?["text_buydetail"] as? String
        }
        
        
        self.titleArr = ["0":[["title":(dataSource?["text_sellamount"] as! String),"detail":(dic["amount"] as! String)],
                              ["title":(dataSource?["text_buyerpay"] as! String),"detail":""],
                              ["title":(dataSource?["text_status"] as! String),"detail":(dic["status"] as! String)],
                              ["title":(dataSource?["text_buyername"] as! String),"detail":""],
                              ["title":(dataSource?["text_cash_phone"] as! String),"detail":phone],
                              ["title":(dataSource?["text_buyerinvoice"] as! String),"detail":""]],
                         "1":[["title":(dataSource?["text_cash_cardnumber"] as! String),"detail":(dataSource?["card_number"] as! String)],
                              ["title":(dataSource?["text_cash_bank"] as! String),"detail":(dataSource?["bank"] as! String)],
                              ["title":(dataSource?["text_cash_cardholder"] as! String),"detail":(dataSource?["card_holder"] as! String)],
                              ["title":(dataSource?["text_cash_alipay"] as! String),"detail":(dataSource?["alipay"] as! String)],
                              ["title":(dataSource?["text_cash_bitcoin"] as! String),"detail":(dataSource?["bitcoin"] as! String)]]]
        self.sectionLabel.text = self.dataSource?["text_cash_accountinfo1"] as? String
        
        self.requestCashDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    public class func getInstance() -> CashDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "cashDetail")
        return vc as! CashDetailViewController
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        }else{
            return (self.titleArr![String(section)]?.count)!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 48
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 4 {
                if self.detailInfo != nil {
                    if (self.detailInfo?["phone"] as! String).characters.count > 0 {
                        return 55
                    }else{
                        return 0
                    }
                }else{
                    return 0
                }
            }else if indexPath.row == 5 {
                if self.type == .sell{
                    if self.detailInfo != nil {
                        if (self.detailInfo?["image"] as! String).characters.count > 0 {
                            return 55
                        }else{
                            return 0
                        }
                    }else{
                        return 0
                    }
                }
            }
        }
        return 55
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "Cell"
        if indexPath.section == 0 && indexPath.row == 5 {
            cellIdentify = "imgCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        let dic = self.titleArr?[String(indexPath.section)]?[indexPath.row]
        (cell.viewWithTag(1) as! UILabel).text = dic?["title"]
        if indexPath.section == 0 && indexPath.row == 5 {
            if self.type == .sell {
                print(dic?["detail"] ?? "")
                if dic?["detail"] != nil && (dic?["detail"]?.characters.count)! > 0 {
                    (cell.viewWithTag(2) as! UIImageView).sd_setImage(with: URL(string: (dic?["detail"])!)!)
                }
            }else {
                if self.currentImg != nil {
                    (cell.viewWithTag(2) as! UIImageView).image = self.currentImg
                }else{
                    (cell.viewWithTag(2) as! UIImageView).image = UIImage(named: "finance-add")
                }
            }
        }else{
            (cell.viewWithTag(2) as! UITextField).text = dic?["detail"]
        }
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 5 {
            if self.type == .sell {
                self.navigationController?.view.addSubview(self.imgBg)
                self.imgBg.mas_makeConstraints({ (make) in
                    _ = make?.top.equalTo()(self.navigationController?.view.mas_top)
                    _ = make?.left.equalTo()(self.navigationController?.view.mas_left)
                    _ = make?.bottom.equalTo()(self.navigationController?.view.mas_bottom)
                    _ = make?.right.equalTo()(self.navigationController?.view.mas_right)
                })
                let dic = self.titleArr?[String(indexPath.section)]?[indexPath.row]
                self.imageView.sd_setImage(with: URL(string: (dic?["detail"])!)!)
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: ({
                    self.imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
                }), completion: {(_ finish:Bool) -> Void in
                    UIView.animate(withDuration: 0.23, delay: 0, options: .curveEaseInOut, animations: ({
                        self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    }), completion: {(_ finish:Bool) -> Void in
                        UIView.animate(withDuration: 0.09, delay: 0.02, options: .curveEaseInOut, animations: ({
                            self.imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        }), completion: {(_ finish:Bool) -> Void in
                            UIView.animate(withDuration: 0.05, delay: 0.02, options: .curveEaseInOut, animations: ({
                                self.imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            }), completion: {(_ finish:Bool) -> Void in
                                
                            })
                        })
                    })
                })
                
            }else{
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let photoAction = UIAlertAction(title: "相册", style: .default, handler: { (alertAction) in
                    let imgPicker = UIImagePickerController.init()
                    imgPicker.sourceType = .savedPhotosAlbum
                    imgPicker.delegate = self
                    self.present(imgPicker, animated: true, completion: nil)
                })
                let cameraAction = UIAlertAction(title: "相机", style: .default, handler: { (alertAction) in
                    let imgPicker = UIImagePickerController.init()
                    imgPicker.sourceType = .camera
                    imgPicker.delegate = self
                    self.present(imgPicker, animated: true, completion: nil)
                })
                let cancelActoin = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(photoAction)
                alert.addAction(cameraAction)
                alert.addAction(cancelActoin)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UIImagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        currentImg = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
        
        let dict = (self.dataSource?["bonus_coins"] as! NSArray)[(self.currentIndexPath?.row)!] as! NSDictionary
        FileNetWorkModel.init(with: ["file_sell_id":(dict["detail"] as! String)], url: "index.php?route=finance/coin/uploadReceipt&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, img: currentImg!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            print(request.responseObject ?? "")
        }) { (request) in
            
        }
        
        
    }
    
    @IBAction func dismissImgView(_ sender: Any) {
        self.imgBg.removeFromSuperview()
    }
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        self.showAlert()
    }
    
    func showAlert() -> Void {
        var title = self.dataSource?["text_payment_info"] as? String
        var detail = self.dataSource?["text_payment_name"] as? String
        var placeholder = self.dataSource?["text_input_payment_name"] as? String
        if self.type == .sell {
            title = self.dataSource?["text_cash_psw"] as? String
            detail = self.dataSource?["text_cash_psw"] as? String
            placeholder = self.dataSource?["text_cash_psw"] as? String
        }
        let alert = UIAlertController.init(title: title, message: detail, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = placeholder
            if self.type == .sell {
                textField.isSecureTextEntry = true
            }else{
                
            }
        }
        let sureAction = UIAlertAction(title: self.dataSource?["text_cash_submit"] as? String, style: .default) { (action) in
            SVProgressHUD.show()
            let dict = (self.dataSource?["bonus_coins"] as! NSArray)[(self.currentIndexPath?.row)!] as! NSDictionary
            var url = "index.php?route=finance/coin/confirmPayment&token="
            var postdDic = ["sell_id":(dict["detail"] as! String)]
            if self.type == .sell {
                
            }else{
                url = "index.php?route=finance/coin/anouncePayment&token="
                if (alert.textFields?[0].text?.characters.count)! > 0 {
                    postdDic["payment_name"] = (alert.textFields?[0].text)!
                }
            }
            url = url + (UserDefaults.standard.object(forKey: "token") as? String)!
            NetworkModel.init(with: postdDic as NSDictionary?, url: url , requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
                let dic:NSDictionary = request.responseObject as! NSDictionary
                if Int(dic["login"] as! String) == 1 {
                    if dic["success"] != nil {
                        SVProgressHUD.dismiss()
                        _ = self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3])!, animated: true)
                    }else{
                        if self.type == .buy{
                            SVProgressHUD.showError(withStatus: (self.dataSource?["error_payment_name"] as! String))
                        }else{
                            SVProgressHUD.showError(withStatus: "")
                            self.showAlert()
                        }
                    }
                }else{
                    self.dismiss(animated: true, completion: nil)
                    SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
                }
            }, failure: { (request) in
                SVProgressHUD.dismiss()
            })
        }
        var cancelTitle = "取消"
        if UserDefaults.standard.object(forKey: "language") != nil {
            if (UserDefaults.standard.object(forKey: "language") as! String) == "cn" {
                cancelTitle = "取消"
            }else{
                cancelTitle = "Cancel"
            }
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (cation) in
            
        }
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func requestCashDetail() {
        SVProgressHUD.show()
        
        let dict = (self.dataSource?["bonus_coins"] as! NSArray)[(self.currentIndexPath?.row)!] as! NSDictionary
        var url = ""
        if self.type == .sell {
            url = "https://www.usacl.com/app/v1/index.php?route=finance/coin/openSellInfo&token="
        }else{
            url = "https://www.usacl.com/app/v1/index.php?route=finance/coin/openBuyInfo&token="
        }
        
        var req = URLRequest(url: URL(string: url + (UserDefaults.standard.object(forKey: "token") as? String)!)!)
        let body = "sell_id=" + (dict["detail"] as! String)
        let bodyData = body.data(using: .utf8)
        req.httpBody = bodyData
        req.httpMethod = "POST"
        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue()) { (response, data, error) in
            do {
                if error == nil {
                    let dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    DispatchQueue.main.async(execute: {
                        if Int(dic["login"] as! String) == 1 {
//                            print(dic)
                            self.detailInfo = dic
                            
                            if self.type == .sell {
                                if (dic["status_id"] as? String) == "3" {
                                    self.footerView.isHidden = false
                                    self.commitBtn.setTitle(dic["text_receiveconfirm"] as? String, for: .normal)
                                }else{
                                    self.footerView.isHidden = true
                                }
                                self.titleArr = ["0":[["title":(dic["text_sellamount"] as! String),"detail":(dic["amount"] as! String)],
                                                      ["title":(dic["text_buyerpay"] as! String),"detail":(dic["real_amount"] as! String)],
                                                      ["title":(dic["text_status"] as! String),"detail":(dic["status"] as! String)],
                                                      ["title":(dic["text_buyername"] as! String),"detail":(dic["customer_name"] as! String)],
                                                      ["title":(dic["text_cash_phone"] as! String),"detail":(dic["phone"] as! String)],
                                                      ["title":(dic["text_buyerinvoice"] as! String),"detail":(dic["image"] as! String)]],
                                                 "1":[["title":(dic["text_cash_cardnumber"] as! String),"detail":(self.dataSource?["card_number"] as! String)],
                                                      ["title":(dic["text_cash_bank"] as! String),"detail":(self.dataSource?["bank"] as! String)],
                                                      ["title":(dic["text_cash_cardholder"] as! String),"detail":(self.dataSource?["card_holder"] as! String)],
                                                      ["title":(dic["text_cash_alipay"] as! String),"detail":(self.dataSource?["alipay"] as! String)],
                                                      ["title":(dic["text_cash_bitcoin"] as! String),"detail":(self.dataSource?["bitcoin"] as! String)]]]
                            }else {
                                if (dic["status_id"] as? String) == "2" {
                                    self.footerView.isHidden = false
                                    self.commitBtn.setTitle(dic["text_payment_confirm"] as? String, for: .normal)
                                }else{
                                    self.footerView.isHidden = true
                                }
                                self.titleArr = ["0":[["title":(dic["text_sellamount"] as! String),"detail":(dic["amount"] as! String)],
                                                      ["title":(dic["text_buyerpay"] as! String),"detail":(dic["real_amount"] as! String)],
                                                      ["title":(dic["text_status"] as! String),"detail":(dic["status"] as! String)],
                                                      ["title":(dic["text_seller_name"] as! String),"detail":(dic["customer_name"] as! String)],
                                                      ["title":(dic["text_cash_phone"] as! String),"detail":(dic["phone"] as! String)],
                                                      ["title":(dic["text_buyerinvoice"] as! String),"detail":(dic["status"] as! String)]],
                                                 "1":[["title":(dic["text_cash_cardnumber"] as! String),"detail":(self.dataSource?["card_number"] as! String)],
                                                      ["title":(dic["text_cash_bank"] as! String),"detail":(self.dataSource?["bank"] as! String)],
                                                      ["title":(dic["text_cash_cardholder"] as! String),"detail":(self.dataSource?["card_holder"] as! String)],
                                                      ["title":(dic["text_cash_alipay"] as! String),"detail":(self.dataSource?["alipay"] as! String)],
                                                      ["title":(dic["text_cash_bitcoin"] as! String),"detail":(self.dataSource?["bitcoin"] as! String)]]]
                            }
                            
                            self.tableView.reloadData()
                            SVProgressHUD.dismiss()
                        }else{
                            self.dismiss(animated: true, completion: nil)
                            SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
                        }
                    })
                    
                    
                }else {
                    
                    DispatchQueue.main.async(execute: {
                        print(error!)
                    })
                }
            }catch{
                
            }
        }
        
    }

}
