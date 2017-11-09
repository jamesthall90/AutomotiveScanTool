//
//  LoginViewController.swift
//  AST
//
//  Created by James Hall on 10/4/17.
//  Copyright © 2017 OP. All rights reserved.
//

import UIKit
import ParticleSDK
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func loginButton(_ sender: Any) { //
        
        //Stores the user-entered email & password values into variables using the guard statement
        //which checks to ensure that the String optionals have a value present
        guard let email = emailField.text, let password = passwordField.text else{ //
            return
        }
        
        ParticleCloud.sharedInstance().login(withUser: email, password: password) { (error:Error?) -> Void in
            if let _ = error {
                print("Wrong credentials or no internet connectivity, please try again")
                
                //Creates a UIAlertController which will display the error
                let loginFailureAlertController = UIAlertController(title: "Login Failure", message:
                    error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                //Specifies the text and behavior of the button attached to the UIAlertController
                loginFailureAlertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default,handler: nil))
                
                //Causes the controller to display on-screen with animation
                self.present(loginFailureAlertController, animated: true, completion: nil)
            }
            else {
                print("Logged in to Particle!")
                
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    
                    //If an error has been caught
                    if error != nil{
                        
                        print("User does not exist! Attempting to create user...")
                        //Attempts to create a new user in the DB with values stored from user input
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                
                                print(error?.localizedDescription as Any)
                                return
                            }
                            
                            //Stores the created user's unique uid into a variable using the guard statement which checks to ensure that the optional FIRUser?.uid field has a value present
                            guard let uid = user?.uid else {
                                return
                            }
                            
                            //User was successfully created
                            print("User successfully created!")
                            
                            //Initializes reference to Firebase object
                            let ref  : DatabaseReference! = Database.database().reference()
                            
                            //Creates a child object in the referenced database
                            let userReference = ref.child("users")
                            
                            //values dictionary holds values to be updated into referenced database
                            let values = ["email": email]
                            
                            //Adds an additional child which is set as the user's unique user id, and then updates said child with values that have been stored in above-declared values dictionary
                            userReference.child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
                                
                                if err != nil {
                                    
                                    print(err!)
                                    return
                                }
                            })
                        })
                        
                        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                            
                            if error != nil {
                                print(error?.localizedDescription as Any)
                                return
                            }
                            print("User has been created and signed-in!")
                            //Once the user has been created, segue switches views to Main Menu
                            self.performSegue(withIdentifier: "deviceSelectSegue", sender: self)
                        }
                    
                    }
                    else {
                        
                        print("Logged in to Firebase!")
                        //Once the user has been created, segue switches views to Main Menu
                        self.performSegue(withIdentifier: "deviceSelectSegue", sender: self)
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}

