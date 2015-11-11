//
//  SignInViewController.swift
//  Rating App
//
//  Created by Tilios on 10/14/15.
//  Copyright © 2015 Tilios. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var message: UILabel!
    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var password: UITextField!
    
    
    let user = PFUser()
    
    @IBAction func signIn(sender: AnyObject) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var userEmail    = emailAddress.text
        userEmail        = userEmail!.lowercaseString

        let userPassword = password.text
        
        PFUser.logInWithUsernameInBackground(userEmail!, password:userPassword!) {
            (user, error: NSError?) -> Void in
            
            // check if user is valid
            guard let user = user else {
                self.activityIndicator.stopAnimating()
                
                if let message_error = error?.userInfo["error"] {
                    self.message.text = "Invalid Email or Password"
                    print(message_error)
                }
                
                return
            }
            
            // Check if user has verified their email
            if let email = user["emailVerified"] as? Bool where email {
                // when email verified...
                
                self.testingFieldsCompleted()
                
                // If user is new to login send to profile view
                if user["isNew"] as? Bool == false {
                    user["isNew"] = true
                    
                    /* take to profile */
                    print("user is new")
                } else {
                    print("user is not new")
                }
                
                /* take user to home screen of app */
                print("user has verified")
            } else {
                // when email not verified...
                
                self.password.text = ""
                self.emailAddress.text = ""
                
                self.activityIndicator.stopAnimating()
                
                /* notify them to verify and prompt sign in screen */
                self.message.text = "Please verify account using the link sent to your email before logging in! If you do not verify your email within 24 hours this account will be deleted along with all its Data! \n\n\t-Thanks you!"
                
                print("user has not verified")
            }
        }
    }
    
    func testingFieldsCompleted() {
        if self.password.text == "" {
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
            
            self.message.text = "Please enter Email and Password"
        } else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarView") as! UITabBarController
            self.presentViewController(vc, animated: true, completion: nil)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
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
