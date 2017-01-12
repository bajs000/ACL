//
//  FileNetWorkModel.swift
//  ACL
//
//  Created by YunTu on 2016/12/21.
//  Copyright © 2016年 work. All rights reserved.
//

import UIKit
import YTKNetwork
import AFNetworking

class FileNetWorkModel: YTKRequest {
    
    var _requestParam:NSDictionary = [:]
    var _url:String = ""
    var _requestMethod:YTKRequestMethod = .POST
    var _requestType:YTKRequestSerializerType = .HTTP
    var _img:UIImage?
    
    init(with param:NSDictionary?, url:String,img:UIImage?, requestMethod:YTKRequestMethod, requestType:YTKRequestSerializerType){
        super.init()
        _requestParam = param!
        _url = url
        _requestMethod = requestMethod
        _requestType = requestType
        _img = img
    }
    
    override func requestUrl() -> String {
        return _url
    }
    
    override func requestArgument() -> Any? {
        return _requestParam
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return _requestMethod
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return _requestType
    }
    
    override var constructingBodyBlock: AFConstructingBlock?{
        get{
            if _img != nil{
                return {(_ formData:AFMultipartFormData) -> Void in
                    var data = UIImagePNGRepresentation(self._img!)//UIImageJPEGRepresentation(self._img!, 0.3)
                    let name = String(NSDate.timeIntervalSinceReferenceDate) + ".png"
                    let path = NSHomeDirectory() + "/Documents/" + name
                    do{
                        try data?.write(to: NSURL(fileURLWithPath: path) as URL)
                    }catch{
                        
                    }
                    data = NSData(contentsOfFile: path) as Data?
                    let type = "image/png"
                    let formKey = "file"
                    formData.appendPart(withFileData: data!, name: formKey, fileName: name, mimeType: type)
                }
            }
            return nil
        }
        set(newValue){
            self.constructingBodyBlock = newValue
        }
    }
    
}
