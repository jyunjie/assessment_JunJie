//
//  SignUpViewController.swift
//  Final_Assessment_JunJie
//
//  Created by JJ on 25/08/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registeredBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var userNameSignUpTextField: UITextField!
    @IBOutlet weak var emailSignUpTextField: UITextField!
    @IBOutlet weak var passWordSignUpTextField: UITextField!
    
    var fireBaseRef = FIRDatabase.database().reference()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func onSignUpBtn(sender: AnyObject) {
        
        guard let email = emailSignUpTextField.text, let password = passWordSignUpTextField.text, let userName = userNameSignUpTextField.text
            else{
                return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let user = user {
                let userDict = ["email": email,"username": userName]
                
                //do something
                self.fireBaseRef.child("users").child(user.uid).setValue(userDict)
                NSUserDefaults.standardUserDefaults().setValue(user.uid, forKeyPath: "uid")
                
                User.signIn(user.uid)
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
                
            }else{
                
                let controller = UIAlertController(title: "Error", message: (error?.localizedDescription), preferredStyle: .Alert)
                let dismissBtn = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                controller.addAction(dismissBtn)
                
                self.presentViewController(controller, animated: true, completion: nil)
                
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "HomeSegue"
        {
            
        } else{
            _ = segue.destinationViewController as! LoginViewController
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        
    }
}
