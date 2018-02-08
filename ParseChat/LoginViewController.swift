//
//  ViewController.swift
//  ParseChat
//
//  Created by Brendan Raftery on 2/3/18.
//  Copyright © 2018 Brendan Raftery. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let wrongInputAlert = UIAlertController(title: "Invalid Input", message: "Username or Password is Invalid", preferredStyle: .alert)
    let issueAlert = UIAlertController(title: "Issue Logging In", message:
        "There was an issue logging in. Check credentials and try again", preferredStyle: .alert )
    let signAlert = UIAlertController(title: "Issue Signing Up", message:
        "Username already taken. Please choose a different one", preferredStyle: .alert )

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        // Set up alerts
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            
        }
        
        self.wrongInputAlert.addAction(OKAction)
        self.issueAlert.addAction(OKAction)
        self.signAlert.addAction(OKAction)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        if (!(usernameField.text?.isEmpty)! && !(passwordField.text?.isEmpty)! ) {
            loginUser()
        } else {
            self.present(self.wrongInputAlert, animated: true) {
                self.usernameField.text = ""
                self.passwordField.text = ""
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if (!(usernameField.text?.isEmpty)! && !(passwordField.text?.isEmpty)! ) {
            registerUser()
        } else {
            self.present(self.wrongInputAlert, animated: true) {
                self.usernameField.text = ""
                self.passwordField.text = ""
            }
        }
    }

    func registerUser() {
        // create new user
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground{(success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.present(self.signAlert, animated: true) {
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                }
            } else {
                print("User Registered successfully")
                let backItem = UIBarButtonItem()
                backItem.title = "Log Out"
                self.navigationItem.backBarButtonItem = backItem
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Log Out"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    func loginUser() {
        
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                self.present(self.issueAlert, animated: true) {
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                }
            } else {
                print("User logged in successfully")
                let backItem = UIBarButtonItem()
                backItem.title = "Log Out"
                self.navigationItem.backBarButtonItem = backItem
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
}

