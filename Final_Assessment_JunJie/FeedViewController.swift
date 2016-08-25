//
//  FeedViewController.swift
//  Final_Assessment_JunJie
//
//  Created by JJ on 25/08/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    var firebaseRef = FIRDatabase.database().reference()
    var feed = [String]()
    var friend = [String]()
    var friendKey = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friend.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.friend[indexPath.row]
        cell.detailTextLabel?.text = self.feed[indexPath.row]
        return cell
    }
    
    func getInfo() {

        
        let friendRef = firebaseRef.child("users").child(User.currentUserUid()!).child("friends")
        
        friendRef.observeEventType(.Value, withBlock:  { (snapshot) in
            if let friendDict = snapshot.value as? [String: AnyObject] {
                for (key, _) in friendDict {
                    self.friendKey.append(key)
                    
                }
                self.getFunction2()
            }
        })
    }
    
    func getFunction2() {
    
        for key in friendKey {
            let userFrdRef = firebaseRef.child("status")
            userFrdRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
                if let statusDict = snapshot.value as? [String: AnyObject] {
                    let userID = statusDict["userID"] as! String
                    if (userID == key) {
                        if let status = statusDict["status"] as? String {
                        
                            self.feed.append(status)
                            
                            
                        }
                        self.getFunction(key)
                    }
                }
            })
        }
    }
    
    func getFunction(key: String){
        
            let nameRef = firebaseRef.child("users").child(key)
            nameRef.observeEventType(.Value, withBlock: { (snapshot) in
                if let userDict = snapshot.value as? [String:AnyObject] {
                    let username = userDict["username"] as! String
                    self.friend.append(username)
                    self.tableView.reloadData()
                }
                
            })
        
        }
        
    
    

}
