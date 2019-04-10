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

class signUpScreen: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField2: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        continueButton = RoundedWhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        continueButton.setTitleColor(UIColor.black, for: .normal)
        continueButton.setTitle("Sign-Up", for: .normal)
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
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }
    
    @objc func openImagePicker(_ sender:Any){
        self.present(imagePicker, animated: true, completion: nil)
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
        guard let image = profileImageView.image else { return }
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
        print("Im the dawn")
        
        Auth.auth().createUser(withEmail: email, password: password){user, error in
            if error == nil{
                print("User Created!")
                
                self.uploadProfileImage(image) { url in
                    
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        print("Error0:")
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                print("User display name changed!")
                                
                                self.saveProfile(username: username, profileImageURL: url!) { success in
                                    if success {
                                        self.dismiss(animated: true, completion: nil)
                                    } else {
                                        print("Error1:")
                                        self.ResetFields()
                                    }
                                }
                                
                            } else {
                                print("Error2")
                                self.ResetFields()
                            }
                        }
                    } else {
                        print("Error3:")
                        self.ResetFields()
                    }
                    
                }
                
            } else {
                print("Error4")
                self.ResetFields()
            }
        }
    }
    
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "username": username,
            "photoURL": profileImageURL.absoluteString
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        guard let imageData = image.jpegData(compressionQuality:0.75) else { return }
        
        print("Error5:")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                
                storageRef.downloadURL { url, error in
                    completion(url)
                }
            } else {
                // failed
                completion(nil)
            }
        }
    }
    
    func ResetFields() {
        let alert = UIAlertController(title: "Error signing up.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setContinueButton(enabled: true)
        continueButton.setTitle("Sign-up", for: .normal)
        activityView.stopAnimating()
        
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

extension signUpScreen: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

