//
//  FriendsViewController.swift
//  Final_Assessment_JunJie
//
//  Created by JJ on 25/08/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var userList = [String]()
    var userListUID = [String]()
    var friendKey = [String]()
    let firebaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUser()
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.userList[indexPath.row]
        for key in friendKey{
            if key == self .userListUID[indexPath.row]{
                cell.detailTextLabel?.text = "Friends"
            }else{
                cell.detailTextLabel?.text = self.userListUID[indexPath.row]
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func observeUser() {
        let firebaseRef = FIRDatabase.database().reference()
        let userRef = firebaseRef.child("users")
        
        userRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let tweetDict = snapshot.value as? [String : AnyObject]{
                if snapshot.key != User.currentUserUid(){
                    if let tweetUID = snapshot.key as? String{
                        self.userListUID.append(tweetUID)
                    }
                    if let tweetText = tweetDict["username"] as? String{
                        self.userList.append(tweetText)
                        self.tableView.reloadData()
                    }
                }
            }
            self.checkFriend()
        })
        
    }
    
    func checkFriend (){
        let friendRef = firebaseRef.child("users").child(User.currentUserUid()!).child("friends")
        
        friendRef.observeEventType(.Value, withBlock:  { (snapshot) in
            if let friendDict = snapshot.value as? [String: AnyObject] {
                for (key, _) in friendDict {
                    self.friendKey.append(key)
                }
                
            }
            self.checkTrue()
        })
        
    }
    
    func checkTrue (){
        let array1 = self.userListUID
        let array2 = self.friendKey
        let result = Set(array1).intersect(Set(array2))
        print (result)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "friendProfileSegue"{
            let destination = segue.destinationViewController as! FriendProfileViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            destination.friend_UID = self.userListUID[(indexPath.row)]
            destination.title = self.userList[indexPath.row]
        }
    }
}
