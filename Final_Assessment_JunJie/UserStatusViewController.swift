//
//  UserStatusViewController.swift
//  Final_Assessment_JunJie
//
//  Created by JJ on 25/08/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase

class UserStatusViewController: UIViewController,UITextFieldDelegate {
    var userStatus:String!
    var userStatusKey:String!
    let firebaseRef = FIRDatabase.database().reference()

    @IBOutlet var statusTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusTxtFld.text = userStatus
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.firebaseRef.child("status").child(self.userStatusKey).child("status").setValue(self.statusTxtFld.text)
        self.navigationController?.popViewControllerAnimated(true)
        return true
    }
    


}
