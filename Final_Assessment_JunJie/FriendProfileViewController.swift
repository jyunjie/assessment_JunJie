//
//  FriendProfileViewController.swift
//  Final_Assessment_JunJie
//
//  Created by JJ on 25/08/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase

class FriendProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var friend_UID : String?
    var friends_Status = [String]()
    var friends_UserName : String!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUser()
        observeStatus()
        // Do any additional setup after loading the view.
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendStatus", forIndexPath: indexPath)
        cell.textLabel?.text = "Username: \(self.friends_UserName)"
        cell.detailTextLabel?.text = "Status: \(self.friends_Status[indexPath.row])"
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends_Status.count
    }
    
    func observeStatus() {
        let firebaseRef = FIRDatabase.database().reference()
        let userRef = firebaseRef.child("status")
        
        userRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let tweetDict = snapshot.value as? [String : AnyObject]{
                let userID = tweetDict["userID"] as! String
                if ( userID == self.friend_UID) {
                    if let tweetText = tweetDict["status"] as? String{
                        self.friends_Status.append(tweetText)
                        self.tableView.reloadData()
                    }
                }
            }
        })
        
    }
    func observeUser() {
        let firebaseRef = FIRDatabase.database().reference()
        let userRef = firebaseRef.child("users")
        
        userRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let tweetDict = snapshot.value as? [String : AnyObject]{
                print (snapshot.key)
                if (snapshot.key == self.friend_UID) {
                    if let tweetText = tweetDict["username"] as? String{
                        self.friends_UserName = tweetText
                        self.tableView.reloadData()
                    }
                }
            }
        })
        
    }
    
    @IBAction func addFriend(sender: AnyObject) {
        let firebaseRef = FIRDatabase.database().reference()
        firebaseRef.child("users").child(User.currentUserUid()!).child("friends").child(self.friend_UID!).setValue(true)
    }
    
}
