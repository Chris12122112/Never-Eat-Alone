//
//  ViewController.swift
//  NEA4
//
//  Created by Chris Wang on 1/21/17.
//  Copyright © 2017 Chris Wang. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ViewController: UIViewController {
    
    // Initialize Firebase Database
    var ref = FIRDatabase.database().reference(withPath: "dining-hall-app")
    
    
    
    /* categories
     users
        username
        emas;l 
        pw
     people currently at PKS
        name1
        name2
     people currently ay EVK
     ....
     
 
 */
    
    var signupMode = true
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    // Function to create alerts
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Changing signup/login button text
    @IBOutlet weak var signupOrLogin: UIButton!
    
    // Logging in or signing up
    @IBAction func signupOrLogin(_ sender: Any) {
        
        // Check for non-blank username or passwords
        if emailTextField.text == "" || passwordTextField.text == "" { // NEED TO VERIFY NAME FIELD IS NOT BLANK
            createAlert(title: "Error in form", message: "Please enter both an email and password")
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            // Signup (not login)
            if signupMode {
                FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error == nil {
                        print("User signed up successfully")
                        
                        // Store user info in database
                        self.ref.child("users").child((user?.uid)!).setValue(["email" : self.emailTextField.text, "password" : self.passwordTextField.text, "name" : self.nameTextField.text])
                        
                        // Store user's name in struct
                        Constants.currentUserName = self.nameTextField.text!
                        
                        self.performSegue(withIdentifier: "loggedOn", sender: self)
                    } else {
                        let errorMessage = error!.localizedDescription as String

                        self.createAlert(title: "There was an error with signup", message: errorMessage)
                        print(errorMessage)
                    }
                })
            // Login (not signup)
            } else {
                FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error == nil {
                        print("User signed in successfully")
                        self.performSegue(withIdentifier: "loggedOn", sender: self)
                    } else {
                        let errorMessage = error!.localizedDescription as String
                        self.createAlert(title: "There was an error with signin", message: errorMessage)
                        print(errorMessage)
                    }
                })
            }
        }
    }
    @IBOutlet weak var messageLabel: UILabel!
    
    // Changing already have an account button
    @IBOutlet weak var changeSignupMode: UIButton!
    
    // Changing Sign-up mode
    @IBAction func changeSignupMode(_ sender: Any) {
        if signupMode {
            // Change to login mode
            signupOrLogin.setTitle("Log In", for: [])
            changeSignupMode.setTitle("Sign Up", for: [])
            messageLabel.text = "Don't have an account?"
            nameTextField.alpha = 0.0
            signupMode = false
        } else {
            // Change to signup mode 
            signupOrLogin.setTitle("Sign Up", for: [])
            changeSignupMode.setTitle("Log In", for: [])
            messageLabel.text = "Already have an account?"
            nameTextField.alpha = 1.0
            signupMode = true
        }
    }    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
}

