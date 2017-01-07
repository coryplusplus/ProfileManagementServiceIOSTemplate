//
//  Networking.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/7/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

import Foundation
import Alamofire

func getBearerToken(user: String, password: String,completionHandler: @escaping (String,Bool) -> ()) -> ()
{
    var headers: HTTPHeaders = [:]
    
    if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
        headers[authorizationHeader.key] = authorizationHeader.value
    }
    
    var bearerToken:String = ""
    
    Alamofire.request("http://api.develop.cloudconfidant.com/profileManagementService/webapi/v1/token/teest@cloudconfidant.com", headers: headers)
        .responseJSON {response  in
            switch response.result {
            case .success:
                print("Validation Successful")
                let json = response.result.value as? [String: Any]
                let token = json?["token"] as? String
                if((token) != nil){
                    bearerToken =  token!
                    completionHandler(bearerToken,true)
                }

            case .failure(let error):
                print(error)
                bearerToken =  "None"
                completionHandler(bearerToken,false)

            }

    }
    
}
