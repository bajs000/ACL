//
//  FinanceViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class FinanceViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var sortArr:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "财务"
        let tabbar = self.tabBarController as! ACLTabBarViewController
        if tabbar.languageDic != nil && tabbar.languageDic?["menu"] != nil{
            self.title = (((tabbar.languageDic?["menu"] as! NSDictionary)[UserDefaults.standard.object(forKey: "language") as! String] as! NSArray) as! [String])[3]
        }
        sortArr = [["title":"动态收益","color":UIColor.colorWithHexString(hex: "4c5ec0")],["title":"注册币","color":UIColor.colorWithHexString(hex: "eb6357")],["title":"注册币交易","color":UIColor.colorWithHexString(hex: "bc4cc0")],["title":"现金币","color":UIColor.colorWithHexString(hex: "13b4fc")],["title":"现金币交易","color":UIColor.colorWithHexString(hex: "51c04c")],["title":"US积分","color":UIColor.colorWithHexString(hex: "ffa119")]]
        if tabbar.languageDic != nil {
            sortArr = [["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_dynamic"] as! String,"color":UIColor.colorWithHexString(hex: "4c5ec0")],["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_activation"] as! String,"color":UIColor.colorWithHexString(hex: "eb6357")],["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_expenditure"] as! String,"color":UIColor.colorWithHexString(hex: "bc4cc0")],["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_cashcoin"] as! String,"color":UIColor.colorWithHexString(hex: "13b4fc")],["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_cashcoin_deal"] as! String,"color":UIColor.colorWithHexString(hex: "51c04c")],["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_usreward"] as! String,"color":UIColor.colorWithHexString(hex: "ffa119")]]
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let dic = sortArr[indexPath.row] as! [String:AnyObject]
        cell.viewWithTag(1)?.layer.cornerRadius = 6
        cell.viewWithTag(1)?.backgroundColor = dic["color"] as? UIColor
        (cell.viewWithTag(2) as! UIImageView).image = UIImage(named: "finance-icon-" + String(indexPath.row))
        (cell.viewWithTag(3) as! UILabel).text = dic["title"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let width = Int(164/375 * screenWidth)
        let height = Int(148 * width / 164)
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "listPush", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let list:FinanceListViewController = segue.destination as! FinanceListViewController
        if segue.identifier == "listPush" {
            list.type = FinanceType(rawValue: (sender as! IndexPath).row)!
        }
    }
    
}
