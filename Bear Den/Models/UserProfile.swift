//
//  UserProfile.swift
//  Bear Den
//
//  Created by Genevieve Garrison on 3/24/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//

import Foundation


class UserProfile {
    var uid: String
    var username: String
    var photoURL: URL
    
    
    
    init(uid: String, username: String, photoURL: URL){
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
}
