//
//  ViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/28.
//  Copyright © 2016年 work. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var findPwdBtn: UIButton!
    @IBOutlet weak var festivalLabel: UILabel!
    @IBOutlet weak var userName: PhoneTextField!
    @IBOutlet weak var pwd: PhoneTextField!
    @IBOutlet weak var codeView: CodeTextField!
    @IBOutlet weak var launchView: UIView!
    @IBOutlet weak var launchCircle: UIView!
    var count = 0
    var languageDic:NSMutableDictionary?
    
    @IBAction func languageBtnDidClick(_ sender: Any) {
        var language:String = self.getLanguageAndUserDefault()._language
        let userDefault = self.getLanguageAndUserDefault()._userDefault
        if userDefault.object(forKey: "language") != nil {
            language = userDefault.object(forKey: "language") as! String
        }
        if language == "cn" {
            language = "en"
            SVProgressHUD.show(withStatus: "Setting...")
        }else{
            language = "cn"
            SVProgressHUD.show(withStatus: "设置中...")
        }
        userDefault.set(language, forKey: "language")
        _ = UserDefaults.synchronize(userDefault)
        self.requestLanguage(language)
    }
    
    func requestLanguage(_ language:String) {
        self.requestLogin(language,isLogin: false)
    }
    
    func requestLogin(_ language:String,isLogin:Bool){
        var dic = ["language":language]
        if isLogin {
            dic = ["nickname":self.userName.text ?? "","password":self.pwd.text ?? "","captcha":self.codeView.text ?? "","language":language]
        }
        NetworkModel.init(with: dic as NSDictionary?, url: "index.php?route=common/login", requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (YTKBaseRequest) in
            let dic:NSDictionary = YTKBaseRequest.responseObject as! NSDictionary
            self.languageDic = NSMutableDictionary(dictionary: dic)
            self.festivalLabel.text = dic["text_subtitle"] as? String
            self.userName.placeholder = dic["text_username"] as? String
            self.pwd.placeholder = dic["text_password"] as? String
            self.codeView.placeholder = dic["text_vericode"] as? String
            self.loginBtn.setTitle(dic["text_login"] as? String, for: .normal)
            self.findPwdBtn.setTitle(dic["text_findpsw"] as? String, for: .normal)
            self.perform(#selector(self.endLoading))
            let userDefault = UserDefaults.standard
            if (dic["login"] as! NSNumber).intValue == 1 && isLogin{
                userDefault.set(dic["token"] as? String, forKey: "token")
                _ = UserDefaults.synchronize(userDefault)
                self.getMainMenu()
            }else{
                if isLogin {
                    SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
                }else{
                    SVProgressHUD.dismiss()
                }
            }
        }, failure: {(YTKBaseRequest) in
            print(YTKBaseRequest.error!)
            SVProgressHUD.showError(withStatus: "网络错误")
            self.perform(#selector(self.endLoading))
        })
    }
    
    func getMainMenu() {
        NetworkModel.init(with: [:], url: "index.php?route=common/column_left&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!, requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
            let dic:NSDictionary = request.responseObject as! NSDictionary
            if Int(dic["login"] as! String) == 1{
                self.languageDic?.setValue(request.responseObject as! NSDictionary, forKey: "newmenu")
                self.performSegue(withIdentifier: "mainPush", sender: nil)
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showError(withStatus: dic["error_warning"] as! String)
            }
        }, failure: { (request) in
            SVProgressHUD.showError(withStatus: "请求错误")
        })
    }
    
    func getLanguageAndUserDefault() -> (_language:String,_userDefault:UserDefaults) {
        var language:String = "cn"
        let userDefault = UserDefaults.standard
        if userDefault.object(forKey: "language") != nil {
            language = userDefault.object(forKey: "language") as! String
        }else{
            userDefault.set(language, forKey: "language")
            _ = UserDefaults.synchronize(userDefault)
        }
        return (language,userDefault)
    }
    
    @IBAction func clickOnBg(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction func loginBtnDidClick(_ sender: Any) {
        if self.codeView.code.uppercased() == self.codeView.text?.uppercased() {
            SVProgressHUD.show()
            self.requestLogin(self.getLanguageAndUserDefault()._language, isLogin: true)
            print(self.codeView.code)
        }else{
            if self.getLanguageAndUserDefault()._language == "en" {
                SVProgressHUD.showError(withStatus: "code error!")
            }else{
                SVProgressHUD.showError(withStatus: "验证码错误")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.cornerRadius = 4
        self.findPwdBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
        self.findPwdBtn.layer.borderWidth = 1
        self.findPwdBtn.layer.cornerRadius = 4
        
        self.launchCircle.layer.borderColor = UIColor.white.cgColor
        self.launchCircle.layer.borderWidth = 1
        self.launchCircle.layer.cornerRadius = self.launchCircle.frame.size.width / 2
        
        self.startLoading()
        
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
            self.bgViewTop.constant = -keyboardRect.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(_ notification:Notification) -> Void {
        UIView.animate(withDuration: 0.75, animations: ({
            self.bgViewTop.constant = 0
            self.view.layoutIfNeeded()
        }), completion: {(_ finish:Bool) -> Void in
            
        })
    }
    
    func startLoading() {
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        animation.fromValue = NSNumber.init(value: 0)
        animation.toValue = NSNumber.init(value: 1)
        animation.repeatCount = HUGE
        animation.duration = 2
        self.launchCircle.layer.add(animation, forKey: "a")
        
        let language:String = self.getLanguageAndUserDefault()._language
        self.requestLanguage(language)
    }
    
    func endLoading() {
        UIView.animate(withDuration: 0.5, animations: ({
            self.launchView.alpha = 0
        }), completion: {(_ finish:Bool) -> Void in
            self.launchView.isHidden = true
            self.launchCircle.layer.removeAllAnimations()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "mainPush" {
            let find = segue.destination as! FindPwdViewController
            find.languageDic = self.languageDic
        }else{
            let tabbar:ACLTabBarViewController = segue.destination as! ACLTabBarViewController
            tabbar.languageDic = self.languageDic
        }
    }

}

