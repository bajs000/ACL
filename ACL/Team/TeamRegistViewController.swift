//
//  TeamRegistViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/2.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD


class RegistViewController: UIViewController {
    
    var pageIndex = 0
//    var dataSource:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

enum ScrollType{
    case previous
    case next
}

class TeamRegistViewController: RegistViewController, UIWebViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var nextPage: UIImageView!
    @IBOutlet weak var leftRegistLabel: UILabel!
    @IBOutlet weak var rightRegistLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var scrollTo:((ScrollType) -> Void)?
    var searchBar:UISearchBar?
    
//    override var dataSource: NSDictionary?{
//        didSet{
//            self.leftRegistLabel.text = self.dataSource?["title"] as? String
//            self.rightRegistLabel.text = self.dataSource?["title"] as? String
//        }
//    }
    
    
    @IBAction func previousBtnDidClick(_ sender: Any) {
//        self.scrollTo!(.previous)
        let url = "https://www.usacl.com/app/v1/index.php?route=team/app_tree&arrow=left&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!
        self.webView.loadRequest(URLRequest(url: URL(string: url)!))
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    @IBAction func nextBtnDidClick(_ sender: Any) {
//        self.scrollTo!(.next)
        
        let url = "https://www.usacl.com/app/v1/index.php?route=team/app_tree&arrow=right&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!
        self.webView.loadRequest(URLRequest(url: URL(string: url)!))
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        nextPage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
//        SVProgressHUD.show()
        let req = URLRequest(url: URL(string: "https://www.usacl.com/app/v1/index.php?route=team/app_tree&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!)!)
        self.webView.loadRequest(req)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        searchBar?.showsCancelButton = true
        searchBar?.delegate = self
        searchBar?.placeholder = "在此搜索"
        self.navigationItem.titleView = searchBar
        
        let btn = Helpers.findClass(UIButton.self, at: searchBar!) as! UIButton
        if UserDefaults.standard.object(forKey: "language") != nil {
            if (UserDefaults.standard.object(forKey: "language") as! String) == "en" {
                btn.setTitle("search", for: .normal)
            }else {
                btn.setTitle("搜索", for: .normal)
            }
        }else{
            btn.setTitle("搜索", for: .normal)
        }
    }
    
    //MARK:- UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
        let url = "https://www.usacl.com/app/v1/index.php?route=team/app_tree&token=gqmgwHFsWdOkjuK2hKH71ZOXO4AXxOm1&search_name=" + (searchBar.text)!
        self.webView.loadRequest(URLRequest(url: URL(string: url)!))
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
        let url = "https://www.usacl.com/app/v1/index.php?route=team/app_tree&token=gqmgwHFsWdOkjuK2hKH71ZOXO4AXxOm1&search_name=" + (searchBar.text)!
        self.webView.loadRequest(URLRequest(url: URL(string: url)!))
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        searchBar.text = ""
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        SVProgressHUD.dismiss()
        print(error)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        SVProgressHUD.dismiss()
    }
    
    public class func getInstance() -> TeamRegistViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:TeamRegistViewController = storyboard.instantiateViewController(withIdentifier: "teamRegist") as! TeamRegistViewController
        return vc
    }
    
}
