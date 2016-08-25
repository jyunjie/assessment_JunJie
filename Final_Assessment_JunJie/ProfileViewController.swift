//
//  ProfileViewController.swift
//  Final_Assessment_JunJie
//
//  Created by JJ on 25/08/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let firebaseRef = FIRDatabase.database().reference()
    var userName : String!
    var status = [String]()

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var statusTextFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTextFld.delegate = self
        observeStatus()
        observeUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.status.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.userName
        let selectedItems = self.status[indexPath.row]
        cell.detailTextLabel?.text = selectedItems
        return cell
    }
    
    func observeUser() {
        let firebaseRef = FIRDatabase.database().reference()
        let userRef = firebaseRef.child("users")
        
        userRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let tweetDict = snapshot.value as? [String : AnyObject]{
                print (snapshot.key)
                if (snapshot.key == User.currentUserUid()) {
                    if let tweetText = tweetDict["username"] as? String{
                        self.userName = tweetText
                        self.tableView.reloadData()
                    }
                }
            }
        })
      
    }
    
    func observeStatus() {
        let firebaseRef = FIRDatabase.database().reference()
        let userRef = firebaseRef.child("status")
        
        userRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let tweetDict = snapshot.value as? [String : AnyObject]{
                let userID = tweetDict["userID"] as! String
                if ( userID == User.currentUserUid()) {
                    if let tweetText = tweetDict["status"] as? String{
                        self.status.append(tweetText)
                        self.tableView.reloadData()
                    }
                }
            }
        })
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let commentsUID = NSUUID().UUIDString
        let commentDict = ["status": self.statusTextFld.text!, "userID": User.currentUserUid()!]
        self.firebaseRef.child("status").child(commentsUID).setValue(commentDict)
        self.firebaseRef.child("users").child(User.currentUserUid()!).child("status").child(commentsUID).setValue(true)
        print(statusTextFld.text)
        textField.resignFirstResponder();
        self.tableView.reloadData()
        return true;
    }

    

}
