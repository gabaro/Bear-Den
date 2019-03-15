//
//  firstPage.swift
//  Bear Den
//
//  Created by Genevieve Garrison on 3/5/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//

import UIKit
import Firebase

class firstPage: UIViewController
{

    @IBOutlet weak var loginIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "toFirstPage", sender: self)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    

}
