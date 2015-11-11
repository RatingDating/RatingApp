//
//  DetailSearchUsersViewController.swift
//  Rating App
//
//  Created by Yehuda Lelah on 10/25/15.
//  Copyright © 2015 Tilios. All rights reserved.
//

import UIKit
import Parse

class DetailSearchUsersViewController: UIViewController {

    var user = PFUser.currentUser()
    
    @IBOutlet weak var usersProfileImage: UIImageView!
    @IBOutlet weak var usersBackgroundImage: UIImageView!
    
    @IBOutlet weak var usersName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
