//
//  ProfileEndpoints.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/7/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

import Foundation
import Alamofire

func createProfile(parameters:Parameters,completionHandler: @escaping (String,Bool) -> () ) -> ()
{
    
    Alamofire.request("\(getBaseURL())/profiles", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: defaultHeaders)
        .responseJSON {response  in
            switch response.result {
            case .success:
                print("Validation Successful")
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

func validatePassword(parameters:Parameters,completionHandler: @escaping (String,Bool) -> () ) -> ()
{
    
    Alamofire.request("\(getBaseURL())/password", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: defaultHeaders)
        .responseJSON {response  in
            switch response.result {
            case .success:
                print("Validation Successful")
                let json = response.result.value as? [String: Any]
                print(json)
                
                if let errorMessage = json?["errorMessage"] as? String
                {
                    completionHandler(errorMessage, false)
                }
                else
                {
                    completionHandler("Login Successful",true)
                }
                
                
            case .failure(let error):
                print(error)
                bearerToken =  "None"
                completionHandler("FAILURE",false)
                
            }
            
    }
    
}
