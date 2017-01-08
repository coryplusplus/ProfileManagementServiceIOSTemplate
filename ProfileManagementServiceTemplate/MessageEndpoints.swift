//
//  MessageEndpoints.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/8/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

import Foundation
import Alamofire

func getMessages(queryParameters : String, completionHandler: @escaping ([[String: Any]],Bool) -> () ) -> ()
{
    
    print("Calling get messages endpoint with query parameters: \(queryParameters)")
    Alamofire.request("\(baseURL)/messages?\(queryParameters)", headers: defaultHeaders)
        .responseJSON {response  in
            switch response.result {
            case .success:
                print("Get messages endpoint called successfully")
                print(response.result.value!)
                let messages = response.result.value as? [[String: Any]]
                if((messages) != nil){
                    completionHandler(messages!,true)
                }
                
            case .failure(let error):
                print(error)
                completionHandler([],false)
                
            }
            
    }
    
}
