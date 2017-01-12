//
//  NewsDetailViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/21.
//  Copyright © 2016年 work. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    var newsTitle:String?
    var contentHtml:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = newsTitle
        self.webView.loadHTMLString(self.contentHtml!, baseURL: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
