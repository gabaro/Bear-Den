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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleLogout(_ target: UIButton){
        try! Auth.auth().signOut()
    }

}
