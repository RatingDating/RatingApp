//
//  UserProfileViewController.swift
//  Rating App
//
//  Created by Yehuda Lelah on 10/21/15.
//  Copyright © 2015 Tilios. All rights reserved.
//

import UIKit
import Parse

typealias PhotoTakingHelperCallback = UIImage? -> Void

class UserProfileViewController: UIViewController {
    
    /* Instances */
    var user: PFUser!
    var userRating: PFObject!
    
    var file = PFFile()
    var image: UIImage?
    var bool: Bool!

    @IBOutlet weak var usersBackgroundImage: UIImageView!
    @IBOutlet weak var usersProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var imageView = UIImageView()
    var imagePicker = UIImagePickerController()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = PFUser.currentUser()
        
        // Image Picker Init
        imagePicker.delegate = self
        
        // Users Info
        let first_name = user!["firstName"]
        let last_name  = user!["lastName"]
        let full_name  = "\(first_name) \(last_name)"
        
        
        userName.text? = full_name

        /* Display Images */
        
        // Retrieve Profile Image
        if user?["profileImage"] != nil {
            getImageFromParse(self.usersProfileImage, place: "profileImage")
        } else {
            print("profileImage: no")
        }
        
        // Retrieve Background Image
        if user?["backgroundImage"] != nil {
            getImageFromParse(self.usersBackgroundImage, place: "backgroundImage")
        } else {
            print("backgroundImage: no")
        }
       
        ///* Image Settings: Profile Image *///
        usersProfileImage.layer.backgroundColor = UIColor.clearColor().CGColor
        usersProfileImage.layer.cornerRadius = usersProfileImage.frame.height / 2
        usersProfileImage.layer.borderWidth = 2.0
        usersProfileImage.layer.masksToBounds = true
        usersProfileImage.layer.borderColor = UIColor.blackColor().CGColor
        
        ///* Image Settings: Background Image *///
        usersBackgroundImage.layer.backgroundColor = UIColor.clearColor().CGColor
        usersBackgroundImage.layer.borderWidth = 2.0
        usersBackgroundImage.layer.masksToBounds = true
        usersBackgroundImage.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    /* Select Photo */
    func getPhoto() {
        let imagePickerActionSheet = UIAlertController(title: "Select Image", message: nil, preferredStyle: .ActionSheet)
        
        // Choose from Camer: Take Picture
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: "Take Photo", style: .Default, handler: { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
                imagePicker.delegate = self
                
            })
            
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        // Choose from Photo Library
        let libButton = UIAlertAction(title: "Choose existing photo", style: .Default) { (alert) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            imagePicker.delegate = self
        }
        
        // Cancel
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        imagePickerActionSheet.addAction(libButton)
        imagePickerActionSheet.addAction(cancel)
        
        self.presentViewController(imagePickerActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func usersProfileImageButton(sender: AnyObject) {
        bool = true
        getPhoto()
    }
    
    @IBAction func usersBackgroundImage(sender: AnyObject) {
        bool = false
        getPhoto()
    }
    
    
    // MARK: Upload Images Choosen to Parse
    func uploadImageToParse(image: UIImage?, place: String) {
        user = PFUser.currentUser()
        
        // Image Data
        let imageData = UIImageJPEGRepresentation(image!, 0.8)
        
        // Create Parse File
        file = PFFile(name: "Image", data: imageData!)
        self.user[place] = file
        //self.user["profileImage"] = file
        
        user.saveInBackground()
    }
    
    // MARK: Upload Image to UserRating Class
    func uploadImageToUserRating(image: UIImage?, place: String) {
        userRating = PFObject(className: "UserRating")
        
        // Image Data
        let imageData = UIImageJPEGRepresentation(image!, 0.8)
        
        // Create Parse File
        file = PFFile(name: "Image", data: imageData!)
        self.userRating[place] = file
        
        userRating.saveInBackground()
    }
    
    // MARK: Get Images Saved from Parse
    func getImageFromParse(imageToGet: UIImageView?, place: String!) {
        user = PFUser.currentUser()
        
        //let picture = user["profileImage"] as? PFFile
        let picture = user[place] as? PFFile
        print(picture)
        
        
        // Get Data
        picture?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                imageToGet?.image = UIImage(data: imageData!)
            } else {
                print("\(error)")
            }
        })
    }
}

extension UserProfileViewController: UINavigationControllerDelegate {

}

// MARK: Image Picker Delegate
extension UserProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // Scalling images
            if bool == true {
                usersProfileImage.contentMode = .ScaleAspectFill
                usersProfileImage.image = imagePicked
            }
            
            if bool == false {
                usersBackgroundImage.contentMode = .ScaleAspectFill
                usersBackgroundImage.image = imagePicked
            }
            
            user = PFUser.currentUser()
            
            // MARK: Save Imaged to Parse
            user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if error == nil {

                    // Save Profile Image
                    if self.usersProfileImage.image != nil {
                        self.uploadImageToParse(self.usersProfileImage.image, place: "profileImage")
                        self.uploadImageToUserRating(self.usersProfileImage.image, place: "profileImage")
                        
                        self.file.saveInBackground()
                    } else {
                        print("profileImage did not upload")
                    }
                    
                    // Save Background Image
                    if self.usersBackgroundImage.image != nil {
                        self.uploadImageToParse(self.usersBackgroundImage.image, place: "backgroundImage")
                        self.uploadImageToUserRating(self.usersBackgroundImage.image, place: "backgroundImage")
                        
                        self.file.saveInBackground()
                    } else {
                        print("backgroundImage did not upload")
                    }
                } else {
                    print(error)
                }
            })
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}









