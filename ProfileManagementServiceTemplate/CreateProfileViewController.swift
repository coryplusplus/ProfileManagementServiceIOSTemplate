//
//  CreateProfileViewController.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/7/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

import UIKit
import Alamofire

class CreateProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var avatar: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        avatar.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createProfilePressed(_ sender: AnyObject) {
        
        
        var parameters: Parameters = [:]
        parameters["profileName"] = (userName.text ?? "")
        parameters["firstName"] = (firstName.text ?? "")
        parameters["lastName"] = (lastName.text ?? "")
        parameters["email"] = (email.text ?? "")
        parameters["avatar"] = (avatar.text ?? "")
        parameters["password"] = (password.text ?? "")
        createProfile(parameters: parameters, completionHandler: {(message,success) in
            if(success)
            {
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.performSegue(withIdentifier: "showLoginFromCreateProfile", sender: self)

                }
                let alertController = UIAlertController(title: "Success", message:
                    message, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)

            }
            else{
                let alertController = UIAlertController(title: "Error", message:
                    message, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            
            }
        )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == self.userName) {
            self.firstName.becomeFirstResponder()
        }
        else if (textField == self.firstName) {
            self.lastName.becomeFirstResponder()
            
        } else if (textField == self.lastName) {
            self.email.becomeFirstResponder()
        }
        else if (textField == self.email) {
            self.password.becomeFirstResponder()
        }
        else if (textField == self.password) {
            self.avatar.becomeFirstResponder()
        }
        else if (textField == self.avatar) {
            self.resignFirstResponder()
        }
        else{
            //var thereWereErrors = checkForErrors()
            var thereWereErrors = false
            if !thereWereErrors
            {
                //conditionally segue to next screen
            }
        }
        
        return true
        
    }
    
}
