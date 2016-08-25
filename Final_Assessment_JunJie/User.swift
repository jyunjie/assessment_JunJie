//
//  User.swift
//  Final_Assessment_JunJie
//
//  Created by JJ on 25/08/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import Foundation

class User {
    
    class func signIn(uid:String){
        NSUserDefaults.standardUserDefaults().setValue(uid, forKeyPath: "uid")
    }
    
    class func isSignedIn() -> Bool{
        if let _ = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
            return true
            
        }else{
            return false
        }
    }
    
    class func currentUserUid() -> String?{
        return NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
    }
    
    class func removeUserUid() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("uid")
    }

    
}

