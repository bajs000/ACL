//
//  StockCollectionViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/29.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit

class StockCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
 
    var sortArr:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "股份"
        let tabbar = self.tabBarController as! ACLTabBarViewController
        if tabbar.languageDic != nil && tabbar.languageDic?["menu"] != nil{
            self.title = (((tabbar.languageDic?["menu"] as! NSDictionary)[UserDefaults.standard.object(forKey: "language") as! String] as! NSArray) as! [String])[1]
        }
        sortArr = [["title":"我的股份","color":UIColor.colorWithHexString(hex: "f27b81")],["title":"我的复投","color":UIColor.colorWithHexString(hex: "eabd45")],["title":"拆分明细","color":UIColor.colorWithHexString(hex: "63c4e8")]]
        if tabbar.languageDic != nil {
            sortArr = [["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_myshare"] as! String,"color":UIColor.colorWithHexString(hex: "f27b81")],["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_reinvest"] as! String,"color":UIColor.colorWithHexString(hex: "eabd45")],["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_history"] as! String,"color":UIColor.colorWithHexString(hex: "63c4e8")]]
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
        (cell.viewWithTag(2) as! UIImageView).image = UIImage(named: "stock-icon-" + String(indexPath.row))
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
        if indexPath.row <= 1 {
            self.performSegue(withIdentifier: "stockPush", sender: indexPath)
        }else{
            self.performSegue(withIdentifier: "detailPush", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stockPush" {
            let stock:StockViewController = segue.destination as! StockViewController
            if (sender as! IndexPath).row == 0 {
                stock.type = StockType.Mine
            }else{
                stock.type = StockType.Cast
            }
        }else{
            let detail:StockDetailViewController = segue.destination as! StockDetailViewController
            detail.type = StockDetailType.Split
        }
    }
    
}
