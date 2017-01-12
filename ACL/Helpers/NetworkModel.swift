//
//  NetworkModel.swift
//  ACL
//
//  Created by YunTu on 2016/12/6.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import YTKNetwork

class NetworkModel: YTKRequest {
    
    var _requestParam:NSDictionary = [:]
    var _url:String = ""
    var _requestMethod:YTKRequestMethod = .POST
    var _requestType:YTKRequestSerializerType = .HTTP
    
    init(with param:NSDictionary?, url:String, requestMethod:YTKRequestMethod, requestType:YTKRequestSerializerType){
        super.init()
        _requestParam = param!
        _url = url
        _requestMethod = requestMethod
        _requestType = requestType
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
    
}
