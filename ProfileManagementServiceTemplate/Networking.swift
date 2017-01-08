//
//  Networking.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/7/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

import Foundation
import Alamofire


var bearerToken: String = ""
var defaultHeaders: HTTPHeaders = [:]
var baseURL : String = "http://api.develop.cloudconfidant.com/profileManagementService/webapi/v1"
var loggedInUser: String = ""

func setLoggedInUser(username : String)
{
    loggedInUser = username
}

func getBaseURL() -> String
{
    return baseURL
}
func getBearerToken(user: String, password: String,completionHandler: @escaping (String,Bool) -> ()) -> ()
{
    var headers: HTTPHeaders = [:]
    
    if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
        headers[authorizationHeader.key] = authorizationHeader.value
    }
    
    var bearerToken:String = ""
    
    Alamofire.request("\(baseURL)/token/test@cloudconfidant.com", headers: headers)
        .responseJSON {response  in
            switch response.result {
            case .success:
                print("Validation Successful")
                let json = response.result.value as? [String: Any]
                let token = json?["token"] as? String
                if((token) != nil){
                    bearerToken =  token!
                    setBearerToken(token: bearerToken)
                    completionHandler(bearerToken,true)
                }

            case .failure(let error):
                print(error)
                bearerToken =  "None"
                completionHandler(bearerToken,false)

            }

    }
    
}

func addToDefaultHeader(key: String, value: String)
{
    print("Adding key:\(key) with value \(value) to default headers")
    defaultHeaders[key] = value

}

func setBearerToken(token: String)
{
    bearerToken = token
    print("Set bearer token to \(bearerToken)")
    addToDefaultHeader(key: "Authorization", value: "Bearer \(bearerToken)")
}
