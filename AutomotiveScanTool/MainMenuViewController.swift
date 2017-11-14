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
import AwaitKit
import SwiftyJSON

class MainMenuViewController: UIViewController {
    
    var deviceInfo: ParticleDevice!
    var vehicle: VinRequest!
    var ref: DatabaseReference!
    var uid: String!
    var vin: String!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var yMMLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        yMMLabel.text = self.deviceInfo.name?.lowercased() ?? ""
        
        //Creates a reference to the database
        self.ref = Database.database().reference()

        //Returns an object containing the current user's information
        let user = Auth.auth().currentUser

        if let user = user {

            //Return's the current user's unique ID
            self.uid = user.uid
        }

        vin = "3GNFK16T5YG164967"
//        let vehicle = VinRequest(VIN:self.vin)

        
        //Checks to see whether vehicle already exists in database
//        ref.child("users").child(uid).child("vehicles").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            if snapshot.hasChild(self.vin){
//
//                print("Vehicle exists in database!")
//
//            } else {
//
//                self.pushVehicleInfo(vehicle: VinRequest(VIN:self.vin))
//            }
//        })
        
        
        
        self.getVehicleInfo()
        
//        yMMLabel.text = "\(vehicle.getVehicleYear()) \(vehicle.getVehicleMake()) \(vehicle.getVehicleModel())"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @IBAction func codeHistory(_ sender: UIButton) {
        
        var task = self.deviceInfo!.callFunction("readVIN", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Performed readVin() function with no errors!")
            }
        }
        
        var handler = ParticleCloud.sharedInstance().subscribeToAllEvents(withPrefix: "vin/result", handler: { (event :ParticleEvent?, error : Error?) in
            if let _ = error {
                print ("could not subscribe to Vin Event")
            } else {
                DispatchQueue.main.async(execute: {
                    print("got event with data \(event?.data?.description as! String)")
                })
            }
        })
    }
    
    @IBAction func readCodes(_ sender: UIButton) {
        
        var task = self.deviceInfo!.callFunction("readCodes", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Performed readCodes() function with no errors!")
                let json = JSON(resultCode)
                print(json)
            }
        }
        
        var handler = ParticleCloud.sharedInstance().subscribeToAllEvents(withPrefix: "codes/result", handler: { (event :ParticleEvent?, error : Error?) in
            if let _ = error {
                print ("Performed readVin() function with no errors!")
            } else {
                DispatchQueue.main.async(execute: {
                    print("got event with data \(event?.data?.description as! String)")
                    
                    
                })
            }
        })
        
    }
    @IBAction func clearCodes(_ sender: Any) {
        
        var task = self.deviceInfo!.callFunction("clearCodes", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
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
    
    @IBAction func backButton(_ sender: Any) {
        
        //Segue's to Device List view
        performSegue(withIdentifier: "presentDeviceList", sender: self)
    }
    
    func pushVehicleInfo(vehicle: VinRequest) -> Void {
        
        self.yMMLabel.text = "\(vehicle.getVehicleYear()) \(vehicle.getVehicleMake()) \(vehicle.getVehicleModel())"
        
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
    
    func getVehicleInfo(){
        
        LoadingHud.show(self.view, label: "Loading Data...")
        self.ref.child("users").child(self.uid).child("vehicles").child(self.vin).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            self.yMMLabel.text = "\(value?["vehicle year"] as? String ?? "") \(value?["vehicle make"] as? String ?? "") \(value?["vehicle model"] as? String ?? "")".uppercased()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
//        if self.yMMLabel.text == "2012 kia optima"{
//
//            self.vehicleImage.image = UIImage(named: "kia-optima")
//        }
//
//        if self.yMMLabel.text == "2003 chevrolet suburban"{
        
            self.vehicleImage.image = UIImage(named: "chevy-suburban")
//        }
        
        LoadingHud.hide(self.view)
    }
    
    func flashDevice(device: ParticleDevice){
        
//        func flashFiles(_ filesDict: [AnyHashable: Any], completion: ParticleCompletionBlock?) -> URLSessionDataTask? {
//
//
//        }
    }
}
