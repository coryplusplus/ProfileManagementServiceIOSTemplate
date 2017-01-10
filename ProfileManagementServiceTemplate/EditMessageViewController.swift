//
//  EditMessageViewController.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/8/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class EditMessageViewController: UIViewController {
    
    
    var currentMessage :[String:Any] = [:]
    
    @IBOutlet weak var messageText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        messageText.text = currentMessage["message"] as! String
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateMessage(_ sender: AnyObject) {
        
        var parameters: Parameters = [:]
        parameters["message"] = messageText.text!
        updateMessageCall(parameters: parameters, messageId: currentMessage["id"] as! String, completionHandler: {(updatedMessage,message,success) in
            if(success)
            {
                self.messageText.text = updatedMessage["message"] as! String
                self.present(getAlert(message: "Message Updated Successfully", title: "Success", action: "Dismiss"), animated: true, completion: nil)
                
            }
            else{
                self.present(getAlert(message: message, title: "Error", action: "Dismiss"), animated: true, completion: nil)
                
            }
            
        }
        )
        
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        deleteMessage(messageId: currentMessage["id"] as! String, completionHandler: {(updatedMessage,message,success) in
            if(success)
            {
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
                
            }
            else{
                self.present(getAlert(message: message, title: "Error", action: "Dismiss"), animated: true, completion: nil)
                
            }
            
        }
        )
        
    }
    
}


