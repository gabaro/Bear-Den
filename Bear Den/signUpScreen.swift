//
//  signUpScreen.swift
//  Bear Den
//
//  Created by Genevieve Garrison on 3/5/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseUI

class signUpScreen: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField2: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        continueButton = RoundedWhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        continueButton.setTitleColor(UIColor.black, for: .normal)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - continueButton.frame.height - 24)
        continueButton.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        continueButton.defaultColor = UIColor.white
        continueButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.color = UIColor.gray
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        
        view.addSubview(activityView)
        
        usernameField.delegate = self
        emailField2.delegate = self
        passwordField2.delegate = self
        
        usernameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailField2.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField2.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameField:
            usernameField.resignFirstResponder()
            emailField2.becomeFirstResponder()
        case emailField2:
            emailField2.resignFirstResponder()
            passwordField2.becomeFirstResponder()
        case passwordField2:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    
    //Sets up continue button for func
    func setContinueButton(enabled:Bool)
    {
        if enabled{
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    
    //signs up user
    @objc func handleSignUp() {
        guard let username = usernameField.text else {return}
        guard let password = passwordField2.text else {return}
        guard let email = emailField2.text else {return}
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password){user, error in
            if error == nil && error != nil{
                print("User Created!")
            }else{
                print("Error creating user: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    //checks to see if all text fields have something in them
    @objc func textFieldChanged(_ target:UITextField) {
        let username = usernameField.text
        let email = emailField2.text
        let password = passwordField2.text
        let formFilled = username != nil && username != "" && email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }
    
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        activityView.center = continueButton.center
}
}
