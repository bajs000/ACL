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
    var dataSource:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

enum ScrollType{
    case previous
    case next
}

class TeamRegistViewController: RegistViewController {
    
    @IBOutlet weak var nextPage: UIImageView!
    @IBOutlet weak var leftRegistLabel: UILabel!
    @IBOutlet weak var rightRegistLabel: UILabel!
    var scrollTo:((ScrollType) -> Void)?
    
    override var dataSource: NSDictionary?{
        didSet{
            self.leftRegistLabel.text = self.dataSource?["title"] as? String
            self.rightRegistLabel.text = self.dataSource?["title"] as? String
        }
    }
    
    
    @IBAction func previousBtnDidClick(_ sender: Any) {
        self.scrollTo!(.previous)
    }
    
    @IBAction func nextBtnDidClick(_ sender: Any) {
        self.scrollTo!(.next)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        nextPage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
    }
    
    public class func getInstance() -> TeamRegistViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:TeamRegistViewController = storyboard.instantiateViewController(withIdentifier: "teamRegist") as! TeamRegistViewController
        return vc
    }
    
}
