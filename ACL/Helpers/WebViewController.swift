//
//  WebViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/21.
//  Copyright © 2016年 work. All rights reserved.
//

import UIKit
import SVProgressHUD

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let req = NSURLRequest(url: NSURL(string: self.url!) as! URL)
        self.webView.loadRequest(req as URLRequest)
        SVProgressHUD.show()
        // Do any additional setup after loading the view.
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        print(webView.scrollView.contentSize.height)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    public class func getInstance() -> WebViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "web")
        return vc as! WebViewController
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
