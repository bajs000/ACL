//
//  TeamViewController.swift
//  ACL
//
//  Created by YunTu on 2016/11/30.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class TeamViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var sortArr:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "团队"
        let tabbar = self.tabBarController as! ACLTabBarViewController
        if tabbar.languageDic != nil && tabbar.languageDic?["menu"] != nil{
            self.title = (((tabbar.languageDic?["menu"] as! NSDictionary)[UserDefaults.standard.object(forKey: "language") as! String] as! NSArray) as! [String])[2]
        }
        sortArr = [["title":"所有团队会员","color":UIColor.colorWithHexString(hex: "4c5ec0")],["title":"我的直推会员","color":UIColor.colorWithHexString(hex: "eb6357")],["title":"注册新会员","color":UIColor.colorWithHexString(hex: "13b4fc")]]
        if tabbar.languageDic != nil {
            sortArr = [["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_team"] as! String,"color":UIColor.colorWithHexString(hex: "4c5ec0")],["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_member"] as! String,"color":UIColor.colorWithHexString(hex: "eb6357")],["title":(tabbar.languageDic?["newmenu"] as! NSDictionary)["text_register"] as! String,"color":UIColor.colorWithHexString(hex: "13b4fc")]]
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
        (cell.viewWithTag(2) as! UIImageView).image = UIImage(named: "team-icon-" + String(indexPath.row))
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
            self.performSegue(withIdentifier: "memberPush", sender: indexPath)
        }else{
            self.performSegue(withIdentifier: "registPush", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "memberPush" {
            let team:TeamMemberViewController = segue.destination as! TeamMemberViewController
            if (sender as! IndexPath).row == 0 {
                team.type = TeamType.All
            }else{
                team.type = TeamType.Mine
            }
        }
    }
    
}
