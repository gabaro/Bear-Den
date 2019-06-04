//
//  FourthViewController.swift
//  Bear Den
//
//  Created by 2019 Brandon Garrison on 1/16/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class FourthViewController: UIViewController {
    
    
    @IBOutlet weak var proff: UIImageView!
    @IBOutlet weak var logout: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logout.layer.cornerRadius = (logout.frame.height / 2) + 1
        proff.layer.cornerRadius = (proff.frame.height / 2)
        
        
    }
    
    
    
    @IBAction func handleLogout(_ target: UIButton){
        try! Auth.auth().signOut()
    }

}
