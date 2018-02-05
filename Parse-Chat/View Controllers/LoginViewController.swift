//
//  LoginViewController.swift
//  Parse-Chat
//
//  Created by Eli Scherrer on 2/4/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if the user is already logged in just push them along
        if PFUser.current() != nil {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            })
            print("someone is signed in")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //when the user clicks the sign up button
    @IBAction func signUpClicked(_ sender: Any) {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                //show alert
                let alert = UIAlertController(title: "Sign Up Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("User Registered successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    
    }
    
    //when the user clicks the login button
    @IBAction func loginClicked(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                //show alert
                let alert = UIAlertController(title: "Log in Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
}
