//
//  Helpers.swift
//  ACL
//
//  Created by YunTu on 2016/12/6.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation

class Helpers: NSObject {
    public class func addDownLine(_ _title:String, font:UIFont, color:UIColor) -> NSAttributedString {
        let title = _title
        let tempStr:NSMutableAttributedString = NSMutableAttributedString.init(string: title)
        let range = NSMakeRange(0, title.characters.count)
        let attrs = [
            NSFontAttributeName : font,
            NSForegroundColorAttributeName : color,
            NSUnderlineStyleAttributeName : 1] as [String : Any]
        tempStr.addAttributes(attrs, range: range)
        return tempStr
    }
    
    public class func optimizeString(_ content:String) -> String {
        var tempStr = content.replacingOccurrences(of: "\\r", with: "\r")
        tempStr = tempStr.replacingOccurrences(of: "\\n", with: "\n")
        return tempStr
    }
    
    public class func optimizeMoney(_ money:Double) -> String{
        let formatter:NumberFormatter = NumberFormatter.init()
        formatter.positiveFormat = "###,##0.00;"
        let tempStr = formatter.string(from: NSNumber(value: money))
        return tempStr!
    }
    
    public class func findSuperViewClass(_ className:AnyClass,with view:UIView) -> UIView? {
        var superView:UIView? = view
        for _ in 0...10 {
            superView = superView?.superview
            if superView!.isKind(of: className) {
                return superView
            }
        }
        return superView
    }
}
