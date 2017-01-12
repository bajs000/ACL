//
//  TeamPageViewController.swift
//  ACL
//
//  Created by YunTu on 2016/12/2.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class TeamPageViewController: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    var VCArr = [RegistViewController]()
    
    public class func getInstance() -> TeamPageViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "teamPage") as! TeamPageViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        self.requestRegist()
        
        let vc1 = UserRigstViewController.getInstance()
        vc1.pageIndex = 0
        let vc2 = TeamRegistViewController.getInstance()
        vc2.pageIndex = 1
        vc2.scrollTo = {(_ type:ScrollType) -> Void in
            if type == ScrollType.next {
                self.setViewControllers([self.VCArr[2]], direction: .forward, animated: true, completion: nil)
            }else{
                self.setViewControllers([self.VCArr[0]], direction: .reverse, animated: true, completion: nil)
            }
        }
        let vc3 = UserRigstViewController.getInstance()
        vc3.pageIndex = 2
        
        
        VCArr = [vc1,vc2,vc3]
        self.setViewControllers([VCArr[1]], direction: .forward, animated: true, completion: {(_ finish:Bool) -> Void in
        
        })
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (viewController as! RegistViewController).pageIndex  == 0{
            return VCArr[1]
        }else if (viewController as! RegistViewController).pageIndex  == 1{
            return VCArr[2]
        }else{
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (viewController as! RegistViewController).pageIndex  == 2{
            return VCArr[1]
        }else if (viewController as! RegistViewController).pageIndex  == 1{
            return VCArr[0]
        }else{
            return nil
        }
    }
    
    func requestRegist() -> Void {
        SVProgressHUD.show()
        let req = URLRequest(url: URL(string:"https://www.usacl.com/app/v1/index.php?route=team/register&token=" + (UserDefaults.standard.object(forKey: "token") as? String)!)!)
        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue(), completionHandler: {(_ response:URLResponse?, data:Data?, error:Error?) -> Void in
            SVProgressHUD.dismiss()
            if error == nil {
                do{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    if Int(dic["login"] as! String) == 1 {
                        for vc in self.VCArr {
                            vc.dataSource = dic
                        }
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
