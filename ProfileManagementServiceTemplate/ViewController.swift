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
        getBearerToken(user: "test@cloudconfidant.com", password: "Password123!@#", completionHandler: {token in
            self.bearerToken.text = token
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

