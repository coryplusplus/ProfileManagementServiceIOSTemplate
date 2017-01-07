//
//  ViewController.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/7/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var bearerToken: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getBearerToken(user: "test@cloudconfidant.com", password: "Password123!@#", completionHandler: {(token,success) in
            if(success)
            {
                self.bearerToken.text = token
            }
            else{
                let alertController = UIAlertController(title: "Error", message:
                    "Unable to retrive bearer token! Please make sure your CloudConfidant username and password is correct in the source code", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)

            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

