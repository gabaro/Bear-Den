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
    var author: String
    var text: String
    
    init(id:String, author:String, text: String){
        self.id = id
        self.author = author
        self.text = text
    }
}

