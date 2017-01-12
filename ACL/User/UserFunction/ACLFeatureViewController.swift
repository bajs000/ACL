//
//  ACLFeatureViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit

enum AbortType {
    case Feature
    case Vision
}

class ACLFeatureViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageCenterY: NSLayoutConstraint!
    var detailArr:NSArray = []
    var type:AbortType?
    var dataSource:NSDictionary?
    
    @IBAction func backBtnDidClick(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        detailArr = [["承诺","为会员带来收益","为市场树立表率","为社会创造价值"],["卓越","业内第一品牌","汇聚行业精英","价值推动行动"],["安全","微软资深工程师打造","百万级规模用户支撑","美国顶级服务器环境"],["人性化","最易懂的拆分制度","最优化的网站设计","最舒心的用户体验"],["稳健","精算师鼎力技术依托","优越的金融行业背景","严谨的财富增值策略"]]
        if type == AbortType.Feature{
            
        }else{
            self.pageControl.isHidden = true
        }
        if UIScreen.main.bounds.size.width == 320 {
            pageCenterY.constant = 30
        }
        
        if self.dataSource != nil {
            let arr1 = self.getContentArr((self.dataSource?["text_feature5_cotent"] as? String)!)
            let arr2 = self.getContentArr((self.dataSource?["text_feature4_cotent"] as? String)!)
            let arr3 = self.getContentArr((self.dataSource?["text_feature3_cotent"] as? String)!)
            let arr4 = self.getContentArr((self.dataSource?["text_feature2_cotent"] as? String)!)
            let arr5 = self.getContentArr((self.dataSource?["text_feature1_cotent"] as? String)!)
            detailArr = [[self.dataSource?["text_feature5_title"] as? String,arr1[0],arr1[1],arr1[2]],[self.dataSource?["text_feature4_title"] as? String,arr2[0],arr2[1],arr2[2]],[self.dataSource?["text_feature3_title"] as? String,arr3[0],arr3[1],arr3[2]],[self.dataSource?["text_feature2_title"] as? String,arr4[0],arr4[1],arr4[2]],[self.dataSource?["text_feature1_title"] as? String,arr5[0],arr5[1],arr5[2]]]

        }
        
//        let tabbar = self.tabBarController as! ACLTabBarViewController
//        if tabbar.languageDic != nil {
//            let arr1 = self.getContentArr((tabbar.languageDic?["text_feature5_cotent"] as? String)!)
//            let arr2 = self.getContentArr((tabbar.languageDic?["text_feature4_cotent"] as? String)!)
//            let arr3 = self.getContentArr((tabbar.languageDic?["text_feature3_cotent"] as? String)!)
//            let arr4 = self.getContentArr((tabbar.languageDic?["text_feature2_cotent"] as? String)!)
//            let arr5 = self.getContentArr((tabbar.languageDic?["text_feature1_cotent"] as? String)!)
//            detailArr = [[tabbar.languageDic?["text_feature5_title"] as? String,arr1[0],arr1[1],arr1[2]],[tabbar.languageDic?["text_feature4_title"] as? String,arr2[0],arr2[1],arr2[2]],[tabbar.languageDic?["text_feature3_title"] as? String,arr3[0],arr3[1],arr3[2]],[tabbar.languageDic?["text_feature2_title"] as? String,arr4[0],arr4[1],arr4[2]],[tabbar.languageDic?["text_feature1_title"] as? String,arr5[0],arr5[1],arr5[2]]]
//        }
    }
    
    func getContentArr(_ content:String) -> [String] {
        return content.components(separatedBy: "\\r\\n")
    }
    
    //MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == AbortType.Feature{
            return detailArr.count
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell? = nil
        
        if type == AbortType.Feature{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCell", for: indexPath)
            (cell?.viewWithTag(1) as! UIImageView).image = UIImage(named: "abort-feature-" + String(indexPath.row))
            (cell?.viewWithTag(2) as! UILabel).text = (detailArr[indexPath.row] as! NSArray)[0] as? String
            (cell?.viewWithTag(3) as! UILabel).text = (detailArr[indexPath.row] as! NSArray)[1] as? String
            (cell?.viewWithTag(4) as! UILabel).text = (detailArr[indexPath.row] as! NSArray)[2] as? String
            (cell?.viewWithTag(5) as! UILabel).text = (detailArr[indexPath.row] as! NSArray)[3] as? String
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visionCell", for: indexPath)
            if self.dataSource != nil {
                (cell?.viewWithTag(111) as! UILabel).text = Helpers.optimizeString((self.dataSource?["text_about_content"] as? String)!)
            }
//            let tabbar = self.tabBarController as! ACLTabBarViewController
//            if tabbar.languageDic != nil {
//                (cell?.viewWithTag(111) as! UILabel).text = Helpers.optimizeString((tabbar.languageDic?["text_about_content"] as? String)!)
//            }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(Int(scrollView.contentOffset.x) / Int(self.collectionView.frame.width))
    }
    
}
