//
//  Post.swift
//  Bear Den
//
//  Created by Genevieve Garrison on 3/24/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//

import Foundation



class Post {
    var id: String
    var author: UserProfile
    var text: String
    var timestamp: Double
    
    init(id:String, author:UserProfile, text: String, timestamp: Double){
        self.id = id
        self.author = author
        self.text = text
        self.timestamp = timestamp
    }
}

