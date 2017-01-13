//
//  FinanceTimeViewController.swift
//  ACL
//
//  Created by YunTu on 2017/1/13.
//  Copyright © 2017年 work. All rights reserved.
//

import UIKit

class FinanceTimeViewController: UITableViewController {
    
    var dataSource: NSDictionary?
    var currentIndexPath: IndexPath?
    var datePicker1: UIDatePicker?
    var datePicker2: UIDatePicker?
    var sellType = "0"
    var showError = false
    var titleArr:[[String:String]] = [["title":"","detail":"","placeholder":""],
                                      ["title":"","detail":"","placeholder":""],
                                      ["title":"","detail":"","placeholder":""],
                                      ["title":"","detail":"","placeholder":""]]
    
    var complete:(([String:String]) -> Void)?

    @IBOutlet weak var commitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commitBtn.layer.cornerRadius = 6
        self.titleArr = [["title":(self.dataSource?["text_username"] as! String),"detail":"","placeholder":""],
                         ["title":(self.dataSource?["text_transfer_type"] as! String),"detail":"0","placeholder":""],
                         ["title":(self.dataSource?["text_start_date"] as! String),"detail":"","placeholder":(self.dataSource?["text_date_format"] as! String)],
                         ["title":(self.dataSource?["text_end_date"] as! String),"detail":"","placeholder":(self.dataSource?["text_date_format"] as! String)]]
        self.title = (self.dataSource?["text_customer_activation_transfer"] as! String)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    public class func getInstance() -> FinanceTimeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "financeTime")
        return vc as! FinanceTimeViewController
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentIndexPath == indexPath {
            return 253
        }
        return 55
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.row == 0 {
            cellIdentify = "userCell"
        }else if indexPath.row == 1 {
            cellIdentify = "Cell"
        }else{
            cellIdentify = "timeCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.row == 2 {
            self.datePicker1 = cell.viewWithTag(3) as? UIDatePicker
            self.datePicker1?.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }else if indexPath.row == 3 {
            self.datePicker2 = cell.viewWithTag(3) as? UIDatePicker
            self.datePicker2?.minimumDate = self.datePicker1?.date
            self.datePicker2?.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }else if indexPath.row == 1 {
            (cell.viewWithTag(9) as! UIButton).addTarget(self, action: #selector(sellTypeSelected(_:)), for: .touchUpInside)
        }
        (cell.viewWithTag(2) as? UITextField)?.placeholder = self.titleArr[indexPath.row]["placeholder"]
        (cell.viewWithTag(2) as? UITextField)?.text = self.titleArr[indexPath.row]["detail"]
        (cell.viewWithTag(1) as! UILabel).text = self.titleArr[indexPath.row]["title"]
        
        (cell.viewWithTag(2) as? UITextField)?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        if showError && self.titleArr[indexPath.row]["detail"]?.characters.count == 0 {
            let textField = cell.viewWithTag(2) as? UITextField
            textField?.layer.cornerRadius = 4
            textField?.layer.borderColor = UIColor.red.cgColor
            textField?.layer.borderWidth = 1
            (textField as? UITextFieldFactory)?.placeholderColor = UIColor.red
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1 {
            currentIndexPath = indexPath
            self.tableView.reloadRows(at: [currentIndexPath!], with: .automatic)
        }
    }

    func datePickerValueChanged(_ datePicker: UIDatePicker){
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: datePicker)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "yyyy-MM-dd"
        (cell?.viewWithTag(2) as! UITextField).text = dateFormat.string(from: datePicker.date)
        self.titleArr[(indexPath?.row)!]["detail"] = dateFormat.string(from: datePicker.date)
    }
    
    func textDidChange(_ sender:UITextField){
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        var dic = titleArr[(indexPath?.row)!]
        dic["detail"] = sender.text
        titleArr.remove(at: (indexPath?.row)!)
        titleArr.insert(dic, at: (indexPath?.row)!)
    }
    
    func sellTypeSelected(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sellType = "1"
        }else{
            sellType = "0"
        }
        var dic = titleArr[1]
        dic["detail"] = sellType
        titleArr.remove(at: 1)
        titleArr.insert(dic, at: 1)
    }
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        if self.complete != nil {
            var dic:[String:String] = [String:String]()
            var i = 0
            for dict in titleArr {
                if dict["detail"]?.characters.count == 0 {
                    showError = true
                    self.tableView.reloadData()
                    return
                }
                dic[String(i)] = dict["detail"]
                i = i + 1
            }
            self.complete!(dic)
            print(dic)
            _ = self.navigationController?.popViewController(animated: true)
        }
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

}
