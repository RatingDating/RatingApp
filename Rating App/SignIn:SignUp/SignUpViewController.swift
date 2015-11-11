//
//  SignUpViewController.swift
//  Rating App
//
//  Created by Tilios on 10/11/15.
//  Copyright © 2015 Tilios. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var message: UILabel!
    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    
    /* Confirm Sign Up */
    @IBAction func signUp(sender: AnyObject) {
        let alert = UIAlertController(title: "Terms and Conditions", message: "Tap to accept or decline our Terms and Conditions", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "I AGREE", style: .Default, handler: { alert in self.processSignUp()}))
        alert.addAction(UIAlertAction(title: "I DO NOT AGREE", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    /* Sign Up */
    func processSignUp() {
        let user = PFUser()
        
        let userRating = PFObject(className: "UserRating")
        
        let email = emailAddress.text
        let pass  = password.text
        let first = firstName.text?.capitalizedString
        let last  = lastName.text?.capitalizedString
        let composite = "\(first!) \(last!)"
        
        if pass != nil || first != nil || last != nil {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            
            // Create user
            user.username         = email
            user.password         = pass
            user.email            = email
            user["firstName"]     = first
            user["lastName"]      = last
            user["compositeName"] = composite
            user["isNew"]         = false
            
            userRating["compositeName"] = composite
            userRating["rating"] = 0
            userRating.objectId = user.objectId
        }
 
        user.signUpInBackgroundWithBlock { (succeeded: Bool,  error: NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.testingFieldsCompleted()
                    
                    userRating.saveInBackground()
                }
            } else {
                self.activityIndicator.stopAnimating()
                if let message_error: AnyObject = error!.userInfo["error"] {
                    self.message.text = "Invalid Email"
                    print(message_error)
                }
            }
        }
    }
    
    func testingFieldsCompleted() {
        if self.emailAddress.text == "" || self.password.text == "" || self.firstName.text == "" || self.lastName.text == "" {
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
            
            self.message.text = "Please Fill out ALL Required Fields."
        } else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignInView") as! SignInViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func haveAccount(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignInView") as! SignInViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
       override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
