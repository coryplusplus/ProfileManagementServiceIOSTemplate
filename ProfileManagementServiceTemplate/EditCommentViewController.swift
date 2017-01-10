
//  EditMessageViewController.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/8/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class EditCommentViewController: UIViewController {
    
    
    var currentComment :[String:Any] = [:]
    
    @IBOutlet weak var commentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        commentText.text = currentComment["message"] as! String
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateComment(_ sender: AnyObject) {
        
        var parameters: Parameters = [:]
        parameters["message"] = commentText.text!
        parameters["author"] = loggedInUser
        updateCommentCall(parameters: parameters,messageId: currentComment["messageId"] as! String, commentId: currentComment["id"] as! String, completionHandler: {(updatedMessage,message,success) in
            if(success)
            {
                self.commentText.text = updatedMessage["message"] as! String
                self.present(getAlert(message: "Comment Updated Successfully", title: "Success", action: "Dismiss"), animated: true, completion: nil)
                
            }
            else{
                self.present(getAlert(message: message, title: "Error", action: "Dismiss"), animated: true, completion: nil)
                
            }
            
        }
        )
        
    }
    
    
}
