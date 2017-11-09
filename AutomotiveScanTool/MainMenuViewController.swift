//
//  ViewController.swift
//  AST
//
//  Created by James Hall on 10/12/17.
//  Copyright © 2017 OP. All rights reserved.
//

import UIKit
import FirebaseAuth
import ParticleSDK
import FirebaseDatabase
import FirebaseAuth

class MainMenuViewController: UIViewController {
    
    var deviceInfo: ParticleDevice!
    var vehicle: VinRequest!
    var ref: DatabaseReference!
    var uid: String!
    var vin: String!
    @IBOutlet weak var yMMLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yMMLabel.text = self.deviceInfo.name?.lowercased() ?? ""
        
        //Creates a reference to the database
        self.ref = Database.database().reference()

        //Returns an object containing the current user's information
        let user = Auth.auth().currentUser

        if let user = user {

            //Return's the current user's unique ID
            self.uid = user.uid
        }

        vin = "1FTSW21R98ED08508"
        
        //Checks to see whether vehicle already exists in database
        ref.child("users").child(uid).child("vehicles").observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.hasChild(self.vin){

                print("Vehicle exists in database!")

            } else {

                self.pushVehicleInfo(vehicle: VinRequest(VIN:self.vin))
            }
        })
        
//        yMMLabel.text = "\(vehicle.getVehicleYear()) \(vehicle.getVehicleMake()) \(vehicle.getVehicleModel())"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "vInfoSegue" {
                let vInfo = segue.destination as! VInfoViewController
                
                if ref != nil{
                    
                    vInfo.uid = self.uid
                    vInfo.ref = self.ref
                    vInfo.vin = self.vin
                    vInfo.deviceInfo = self.deviceInfo
                    
                } else {
                    
                    print("Database reference is nil!")
                }
            }
        }
    }
    
    @IBAction func clearCodes(_ sender: Any) {
        
//        let funcArgs
        var task = self.deviceInfo!.callFunction("digitalWrite", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                
                //Creates a UIAlertController which will display the success message
                let clearedAlertController = UIAlertController(title: "Codes Cleared", message:
                    "Your codes have been successfully cleared!", preferredStyle: UIAlertControllerStyle.alert)
                
                //Specifies the text and behavior of the button attached to the UIAlertController
                clearedAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                
                //Causes the controller to display on-screen with animation
                self.present(clearedAlertController, animated: true, completion: nil)
            
            } else{
                
                //Creates a UIAlertController which will display the failure message
                let notClearedAlertController = UIAlertController(title: "Codes Not Cleared", message:
                    "The code-clearing operation was unsuccessful! See error message below.\n \(error?.localizedDescription ?? "")", preferredStyle: UIAlertControllerStyle.alert)
                
                //Specifies the text and behavior of the button attached to the UIAlertController
                notClearedAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                
                //Causes the controller to display on-screen with animation
                self.present(notClearedAlertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func vIButton(_ sender: Any) {
        
        //Segue's to Vehicle Information view
        performSegue(withIdentifier: "vInfoSegue", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        ParticleCloud.sharedInstance().logout()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        //Once the user is logged out, segue switches views to Login
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    func pushVehicleInfo(vehicle: VinRequest) -> Void {
        
        self.ref.child("users").child(self.uid).child("vehicles").child(vehicle.vin).child("vehicle year").setValue(vehicle.getVehicleYear())
        self.ref.child("users").child(self.uid).child("vehicles").child(vehicle.vin).child("vehicle make").setValue(vehicle.getVehicleMake())
        self.ref.child("users").child(self.uid).child("vehicles").child(vehicle.vin).child("vehicle model").setValue(vehicle.getVehicleModel())
        self.ref.child("users").child(self.uid).child("vehicles").child(vehicle.vin).child("vehicle engine").setValue(vehicle.getVehicleEngineSize())
        self.ref.child("users").child(self.uid).child("vehicles").child(vehicle.vin).child("vehicle type").setValue(vehicle.getVehicleType())
        self.ref.child("users").child(self.uid).child("vehicles").child(vehicle.vin).child("vehicle drive type").setValue(vehicle.getVehicleDriveType())
        self.ref.child("users").child(self.uid).child("vehicles").child(vehicle.vin).child("vehicle transmission").setValue(vehicle.getVehicleTransmission())
        self.ref.child("users").child(self.uid).child("vehicles").child(vehicle.vin).child("vehicle fuel type").setValue(vehicle.getVehicleFuelType())
        self.ref.child("users").child(self.uid).child("vehicles").child(vehicle.vin).child("vehicle assembly plant").setValue(vehicle.getVehicleAssemblyPlant())
    }
}
