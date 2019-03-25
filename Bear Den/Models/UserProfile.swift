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
    
    
    init(uid: String, username: String){
        self.uid = uid
        self.username = username
    }
}
