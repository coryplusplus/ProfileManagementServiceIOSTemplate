//
//  Alerts.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/9/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

import Foundation
import UIKit


func getAlert(message: String, title: String, action : String) -> UIAlertController
{
    let alertController = UIAlertController(title: title, message:
        message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.default,handler: nil))
    return alertController

}
