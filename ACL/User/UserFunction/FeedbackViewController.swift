//
//  FeedbackViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/21.
//  Copyright © 2016年 work. All rights reserved.
//

import UIKit
import SVProgressHUD

class FeedbackViewController: UITableViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var choseFileTitle: UILabel!
    @IBOutlet weak var choseFile: UILabel!
    @IBOutlet weak var needKnowTitle: UILabel!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var typeInputView: UIView!
    var dataSource:NSDictionary?
    var selectImg:UIImage?
    var typeText:UITextView?
    var titleText:UITextView?
    var contentText:UITextView?
    
    @IBAction func inputViewSureBtnDidClick(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction func inputViewCancelBtnDidClick(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction func sureBtnDidClick(_ sender: Any) {
        SVProgressHUD.show()
        FileNetWorkModel.init(with: ["feedback_type":"1","feedback_title":self.titleText?.text ?? "","feedback_text":self.contentText?.text ?? ""], url: "index.php?route=information/feedback&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, img: self.selectImg, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1 {
                if ((dic["error_type"] as? String)?.characters.count)! > 0 {
                    SVProgressHUD.showError(withStatus: dic["error_type"] as! String)
                    return
                }
                if ((dic["error_title"] as? String)?.characters.count)! > 0 {
                    SVProgressHUD.showError(withStatus: dic["error_title"] as! String)
                    return
                }
                if ((dic["error_text"] as? String)?.characters.count)! > 0 {
                    SVProgressHUD.showError(withStatus: dic["error_text"] as! String)
                    return
                }
                if ((dic["error_file"] as? String)?.characters.count)! > 0 {
                    SVProgressHUD.showError(withStatus: dic["error_file"] as! String)
                    return
                }
                _ = self.navigationController?.popViewController(animated: true)
                SVProgressHUD.dismiss()
            }else{
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure: { (request) in
            print(request.error!)
        })
    }
    
    @IBAction func choseFileDidClick(_ sender: Any) {
        let imgPicker = UIImagePickerController.init()
        imgPicker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imageAction = UIAlertAction(title: "相册", style: .default, handler: {(_ alert:UIAlertAction) -> Void in
            imgPicker.sourceType = .savedPhotosAlbum
            self.present(imgPicker, animated: true, completion: nil)
        })
        let cameraAction = UIAlertAction(title: "相机", style: .default, handler: {(_ alert:UIAlertAction) -> Void in
            imgPicker.sourceType = .camera
            self.present(imgPicker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(imageAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.sureBtn.layer.cornerRadius = 6
        
        if self.dataSource != nil {
            self.choseFileTitle.text = self.dataSource?["text_feedback_selectfile"] as? String
            self.choseFile.attributedText = Helpers.addDownLine(self.dataSource?["text_feedback_selectfile"] as! String, font: self.choseFile.font,color: UIColor.colorWithHexString(hex: "404146"))
            self.needKnowTitle.text = Helpers.optimizeString(self.dataSource?["text_feedback_mustknow"] as! String)
            self.sureBtn.setTitle(self.dataSource?["text_feedback_submit"] as? String, for: .normal)
            self.title = self.dataSource?["text_feedback_btnfeedback"] as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let textView = cell.viewWithTag(2) as! UITextView
        textView.delegate = self
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.colorWithHexString(hex: "666666").cgColor
        if indexPath.row == 0{
            textView.inputView = self.typeInputView
            self.typeText = textView
            if textView.text.characters.count == 0 {
                textView.text = self.dataSource?["text_feedback_type" + String(1)] as? String
            }
        }else if indexPath.row == 1 {
            textView.inputView = nil
            self.titleText = textView
            (cell.viewWithTag(1) as! UILabel).text = self.dataSource?["text_feedback_title"] as? String
        }else if indexPath.row == 2{
            textView.inputView = nil
            self.contentText = textView
            (cell.viewWithTag(1) as! UILabel).text = self.dataSource?["text_feedback_content"] as? String
        }
        return cell
    }

    func textViewDidChange(_ textView: UITextView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    //MARK:- UIImagePickerViewControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.selectImg = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataSource?["text_feedback_type" + String(row + 1)] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.typeText?.text = self.dataSource?["text_feedback_type" + String(row + 1)] as? String
    }

}
