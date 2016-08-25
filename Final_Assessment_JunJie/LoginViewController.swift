//
//  LoginViewController.swift
//  Final_Assessment_JunJie
//
//  Created by JJ on 25/08/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase



class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailSignInTxtFld: UITextField!
    @IBOutlet weak var passwordSignInTxtFld: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    @IBAction func onLogInBtn(sender: UIButton) {
        dismissKeyboard()
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        guard let email = emailSignInTxtFld.text , let password = passwordSignInTxtFld.text else{
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            if let user = user {
                User.signIn(user.uid)
                print(self.view.backgroundColor)
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
            }else{
                let controller = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                let dismissButton = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                controller.addAction(dismissButton)
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "SignUpSegue"
        {
            dismissKeyboard()
            self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
            _ = segue.destinationViewController as! SignUpViewController
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        
    }
    
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
}
