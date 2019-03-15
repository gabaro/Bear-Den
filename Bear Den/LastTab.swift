//
//  LastTab.swift
//  Bear Den
//
//  Created by Genevieve Garrison on 3/15/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class LastTab: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleLogout(_ target: UIButton){
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }

}
