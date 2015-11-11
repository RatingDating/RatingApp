//
//  SearchViewController.swift
//  Rating App
//
//  Created by Yehuda Lelah on 10/24/15.
//  Copyright © 2015 Tilios. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var users: [(name:String, rating:Float, image:UIImage?)] = []
    var user = PFUser.currentUser()

    var profile = SearchTableViewCell().searchUserProfileImage
    
    var state: State = .DefaultMode {
        didSet {
            switch (state) {
            case .DefaultMode:
                searchBar.text = ""
                searchBar.resignFirstResponder()
                searchBar.showsCancelButton = false
            
            case .SearchMode:
                searchBar.showsCancelButton = true
                searchBar.setShowsCancelButton(true, animated: true)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.registerNib(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchUsers")
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        let userRating = PFQuery(className: "UserRating")
        
        userRating.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects {
                for(var i = 0; i < objects.count; i++){
                    let object = objects[i] as PFObject
                    let name = object.objectForKey("compositeName") as! String
                    let rating = object.objectForKey("rating") as! Float
                    
                    if let profileImage = object.objectForKey("profileImage") as? PFFile {
                        
                        profileImage.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                            if data != nil {
                                let image = UIImage(data: data!)
                                self.users += [(name, rating, image)]
                            } else {
                                self.users += [(name, rating, nil)]
                            }
                            
                            self.sortSearchUsers()
                            
                            self.tableView.reloadData()
                        })
                    } else {
                        self.users += [(name, rating, nil)]
                        self.sortSearchUsers()
                        
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    func sortSearchUsers() {
        self.users.sortInPlace({ (a, b) -> Bool in
            let aPrimary = a.name ?? ""
            let bPrimary = b.name ?? ""
            
            return aPrimary < bPrimary
        })
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchUsers", forIndexPath: indexPath) as! SearchTableViewCell
        
        let row = indexPath.row
        
        cell.searchUserProfileImage.image = users[row].image
        
        
        cell.searchUserProfileImage.contentMode = .ScaleAspectFill
        
        cell.searchUserProfileImage.layer.backgroundColor = UIColor.clearColor().CGColor
        cell.searchUserProfileImage.layer.cornerRadius = cell.searchUserProfileImage.frame.height / 2
        cell.searchUserProfileImage.layer.borderWidth = 2.0
        cell.searchUserProfileImage.layer.masksToBounds = true
        cell.searchUserProfileImage.layer.borderColor = UIColor.blackColor().CGColor
        
        cell.searchUserName.text = users[row].name
        cell.searchUserRate.text = "\(users[row].rating)"
        
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        print("Should End")
        state = .DefaultMode
        
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("Cancel")
        state = .DefaultMode
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        print("tets")
        self.searchBar.showsCancelButton = true
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchName: String) {
        if searchName == "" {
            state = .DefaultMode
        } else {
            state = .SearchMode
        }
        
        
    }
}










