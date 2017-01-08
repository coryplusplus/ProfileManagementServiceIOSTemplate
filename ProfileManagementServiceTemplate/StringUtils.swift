//
//  StringUtils.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/8/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

//
//  StringUtils.swift
//  EncourageMe
//
//  Created by Cory Kelly on 10/15/15.
//  Copyright © 2015 Cory Kelly. All rights reserved.
//

import Foundation
import UIKit
class StringUtils{
    
    static var textMarginHorizontal: CGFloat = 15.0
    static  var textMarginVertical: CGFloat = 25.0
    static  var messageTextSize: CGFloat = 14.0
    
    static func trimWhiteSpace(string : String)->String
    {
        var newString = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        newString = newString.replacingOccurrences(of: "\n", with: "" )
        newString = newString.replacingOccurrences(of: "\"", with: "\\\"" )
        return newString
    }
    
    static func trimAllWhiteSpace(string: String)->String
    {
        var newString = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        newString = newString.replacingOccurrences(of: "\n", with: "" )
        newString = newString.replacingOccurrences(of: " ", with: "" )
        return newString
    }
    
    static func removeQuotes(string: String)->String
    {
        var newString = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        newString = newString.replacingOccurrences(of: "\n", with: "" )
        newString = newString.replacingOccurrences(of: "\"", with: "" )
        newString = newString.replacingOccurrences(of: "\\", with: "" )
        
        return newString
    }
    
    static func heightForView(text:String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:220, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: messageTextSize)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    static func heightForViewAll(text:String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:220, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: messageTextSize)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    static func addQueryParam(params: String, newParam: String) -> String
    {
        return params + "&" + newParam
    }
}
