//
//  StringUtil.swift
//  google_calendar_api
//
//  Created by 中村祐太 on 2016/10/10.
//  Copyright © 2016年 中村祐太. All rights reserved.
//
import Foundation

class StringUtil {
    static func jsonify(data:AnyObject) -> String {
        let dic = data as! Dictionary<String, AnyObject>
        let data = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
    }
}
