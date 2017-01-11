//
//  CommentEndpoints.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/8/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

import Foundation
import Alamofire

func getComments(queryParameters : String, messageId : String,  completionHandler: @escaping ([[String: Any]],Bool) -> () ) -> ()
{
    
    print("Calling get comments endpoint with query parameters: \(queryParameters)")
    print("\(baseURL)/messages/\(messageId)/comments?\(queryParameters)")
    Alamofire.request("\(baseURL)/messages/\(messageId)/comments?\(queryParameters)", headers: defaultHeaders)
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

func createComment(parameters:Parameters, messageId : String, completionHandler: @escaping (String,Bool) -> () ) -> ()
{
    
    Alamofire.request("\(getBaseURL())/messages/\(messageId)/comments", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: defaultHeaders)
        .responseJSON {response  in
            switch response.result {
            case .success:
                let json = response.result.value as? [String: Any]
                print(json)
                
                if let errorMessage = json?["errorMessage"] as? String
                {
                    completionHandler(errorMessage, false)
                }
                else
                {
                    completionHandler("Creation Successful",true)
                }
                
                
            case .failure(let error):
                print(error)
                bearerToken =  "None"
                completionHandler("FAILURE",false)
                
            }
            
    }
    
}

func updateCommentCall(parameters:Parameters, messageId: String, commentId: String, completionHandler: @escaping ([String:Any],String,Bool) -> () ) -> ()
{
    
    Alamofire.request("\(getBaseURL())/messages/\(messageId)/comments/\(commentId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: defaultHeaders)
        .responseJSON {response  in
            switch response.result {
            case .success:
                let json = response.result.value as? [String: Any]
                print(json)
                
                if let errorMessage = json?["errorMessage"] as? String
                {
                    completionHandler(json!,errorMessage, false)
                }
                else
                {
                    completionHandler(json!,"Update Successful",true)
                }
                
                
            case .failure(let error):
                print(error)
                bearerToken =  "None"
                completionHandler([:],"FAILURE",false)
                
            }
            
    }
    
}

func deleteComment(messageId: String, commentId: String, completionHandler: @escaping (String,Bool) -> () ) -> ()
{
    
    Alamofire.request("\(getBaseURL())/messages/\(messageId)/comments/\(commentId)", method: .delete , encoding: JSONEncoding.default, headers: defaultHeaders)
        .responseJSON {response  in
            switch response.result {
            case .success:
                let json = response.result.value as? [String: Any]
                print(json)

                completionHandler("SUCCESS", true)
            case .failure(let error):
                print(error)
                bearerToken =  "None"
                completionHandler("FAILURE",false)
                
            }
            
    }
    
}
