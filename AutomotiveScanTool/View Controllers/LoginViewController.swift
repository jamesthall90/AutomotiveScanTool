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
import ZAlertView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var dialog: ZAlertView!
    
    override func viewDidLoad() {
        
        let astColor = UIColor(red:0.00, green:0.20, blue:0.40, alpha:1.0)
        ZAlertView.blurredBackground = true
        ZAlertView.showAnimation = .bounceBottom
        ZAlertView.hideAnimation = .bounceRight
        ZAlertView.alertTitleFont = UIFont(name: "Copperplate", size: 19)!
        ZAlertView.positiveColor = astColor
        ZAlertView.titleColor = astColor
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    //Opens the Particle iOS application when the button is pressed
    @IBAction func openParticle(_ sender: Any) {
        
        //Initialization of a ZAlertView dialog for displaying the login failure
        self.dialog = ZAlertView(title: "Open Particle", message: "Click \"Okay\" to open the Particle app. Click \"Cancel\" to go back to the Login Screen.", isOkButtonLeft: true, okButtonText: "Open", cancelButtonText: "Cancel", okButtonHandler: { (alertView) -> () in
                
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/particle-build-photon-electron/id991459054?ls=1&mt=8")!)
            alertView.dismissAlertView() }, cancelButtonHandler: { (alertView) -> () in
                alertView.dismissAlertView()
        })
        
        //Prohibits the user from closing the dialog by touching the screen around it
        self.dialog.allowTouchOutsideToDismiss = false
        
        //Shows the dialog
        self.dialog.show()
    }
    
    /*
     Handles logic for: basic null input validation, logging in to the Particle cloud, and logging in to Firebase
    */
    @IBAction func loginButton(_ sender: Any) { //
        
        //Stores the user-entered email & password values into variables using the guard statement
        //which checks to ensure that the String optionals have a value present
        guard let email = emailField.text, let password = passwordField.text else{
            return
        }
        
        //If both the email field & password field are empty, populates their placeholders with warnings
        if emailField.text == "" && passwordField.text == ""{
            
            self.emailField.attributedPlaceholder = NSAttributedString(string: "You Must Enter An Email",
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: UIFont(name: "Copperplate", size: 14)!])
            self.passwordField.attributedPlaceholder = NSAttributedString(string: "You Must Enter A Password!",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: UIFont(name: "Copperplate", size: 14)!])
        //If just the email field is empty, populates its placeholder with a warning
        } else if emailField.text == "" {
            self.emailField.attributedPlaceholder = NSAttributedString(string: "You Must Enter An Email",
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: UIFont(name: "Copperplate", size: 14)!])
        //If just the password field is empty, populates its placeholder with a warning
        } else if passwordField.text == ""{
            
            self.emailField.attributedPlaceholder = NSAttributedString(string: "You Must Enter An Email!",
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: UIFont(name: "Copperplate", size: 14)!])
            self.passwordField.attributedPlaceholder = NSAttributedString(string: "You Must Enter A Password!",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: UIFont(name: "Copperplate", size: 14)!])
        //If both fields are filled, continues with logging in
        } else {
            
            //Displays a warning heads-up display showing that logging in has commenced
            LoadingHud.showHud(self.view, label: "Logging In...")
            
            //Function logs in to the Particle cloud service
            ParticleCloud.sharedInstance().login(withUser: email, password: password) { (error:Error?) -> Void in
                if let _ = error {
                    
                    //Hides the heads-up display when an error is detected
                    LoadingHud.hideHud(self.view)
                    
                    //Prints an error message to the console
                    print("Wrong credentials or no internet connectivity, please try again")
                    
                    //Initialization of a ZAlertView dialog for displaying the login failure
                    self.dialog = ZAlertView(title: "Login Failure",
                                             message: error?.localizedDescription,
                                             closeButtonText: "Try Again",
                                             closeButtonHandler: { (alertView) -> () in
                                                alertView.dismissAlertView()
                    })
                    
                    //Prohibits the user from closing the dialog by touching the screen around it
                    self.dialog.allowTouchOutsideToDismiss = false
                    
                    //Shows the dialog
                    self.dialog.show()
                }
                else {
                    //Prints a message to the console
                    print("Logged in to Particle!")
                    
                    //Firebase Auth asynchronous function, which attempts to sign the user in
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        
                        //If an error has been caught (such as the user not existing)
                        if error != nil{
                            
                            //Prints a warning to the console
                            print("User does not exist! Attempting to create user...")
                            
                            //Attempts to create a new user in the DB with values stored from user input
                            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                                
                                if error != nil {
                                    
                                    print(error?.localizedDescription as Any)
                                    return
                                }
                                
                                /*
                                Stores the created user's unique uid into a variable using the guard statement
                                which checks to ensure that the optional FIRUser?.uid field has a value present
                                */
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
                            
                            //If there are no errors caught and the user already exists, the user is signed in
                            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                                
                                if error != nil {
                                    //Print's the error's description to the console
                                    print(error?.localizedDescription as Any)
                                    return
                                }
                                
                                print("User has been created and signed-in!")
                                
                                //Once the user has been created, segue switches views to Main Menu
                                self.performSegue(withIdentifier: "deviceSelectSegue", sender: self)
                            }
                        }
                        else {
                            
                            //Prints a message to the console
                            print("Logged in to Firebase!")
                            
                            //Once the user has been created, segue switches views to Main Menu
                            self.performSegue(withIdentifier: "deviceSelectSegue", sender: self)
                            
                            //Hides the heads-up display
                            LoadingHud.hideHud(self.view)
                        }
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
}

