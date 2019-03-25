//
//  UserService.swift
//  Bear Den
//
//  Created by Genevieve Garrison on 3/24/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//

import Foundation
import Firebase

class UserService{
    
    
    static var currentUserProfile:UserProfile?
    static func observeUserProfile(_ uid:String, completion:@escaping ((_ userProfile:UserProfile?)->())){
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        
        userRef.observe(.value, with: {  snapshot in
            var userProfile:UserProfile?
            
            if let dict = snapshot.value as? [String:Any],
            let username = dict["username"] as? String{
                    userProfile = UserProfile(uid: snapshot.key, username: username)
            }
            
            completion(userProfile)
        })
        
    }
    
}
