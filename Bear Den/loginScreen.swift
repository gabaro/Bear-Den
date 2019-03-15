//
//  loginScreen.swift
//  Bear Den
//
//  Created by 2019 Brandon Garrison on 1/30/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI

class loginScreen: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
