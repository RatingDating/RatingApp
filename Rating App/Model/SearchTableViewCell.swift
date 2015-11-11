//
//  SearchTableViewCell.swift
//  Rating App
//
//  Created by Yehuda Lelah on 10/25/15.
//  Copyright © 2015 Tilios. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchUserProfileImage: UIImageView!
    @IBOutlet weak var searchUserName: UILabel!
    @IBOutlet weak var searchUserRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
