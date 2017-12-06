//
//  ViewController.swift
//  AST
//
//  Created by James Hall on 10/12/17.
//  Copyright © 2017 OP. All rights reserved.
//  EDIT COMMENTS ON LINES: 22 AND 170 TO RUN WITHOUT DEVICE BEING CONNECTED!!!
//

import UIKit
import FirebaseAuth
import ParticleSDK
import FirebaseDatabase
import AwaitKit
import SwiftyJSON
import ZAlertView
import Alamofire
import Font_Awesome_Swift

class MainMenuViewController: UIViewController {
    
    //    Remove comment to use with device, and comment the hardcoded vin below
    var vin: String!
//    var vin: String! = "2G1FE1ED7B9118397"
    
    
    var handler: Any?
    var deviceInfo: ParticleDevice!
    var vehicle: VinRequest!
    var ref: DatabaseReference!
    var uid: String!
    var dateString: String!
    var parameters: Parameters?
    var apiURL: URL!
    var vinPath: String!
    var vehicleData: JSON!
    var dialog: ZAlertView!
    var vehicleStruct: Vehicle?
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var yMMLabel: UILabel!
    @IBOutlet weak var vinLabel: UILabel!
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonOutlet.setFAIcon(icon: .FAChevronLeft, iconSize: 25, forState: .normal)
        
        let astColor = UIColor(red:0.00, green:0.20, blue:0.40, alpha:1.0)
        ZAlertView.blurredBackground = true
        ZAlertView.showAnimation = .bounceBottom
        ZAlertView.hideAnimation = .bounceRight
        ZAlertView.alertTitleFont = UIFont(name: "Copperplate", size: 19)!
        ZAlertView.positiveColor = astColor
        ZAlertView.titleColor = astColor
        
        //Creates a reference to the database
        self.ref = Database.database().reference()
        
        self.vinPath = "\(AppDelegate.getAppDelegate().getDocDir())/decoded-vin.json"
        
        self.apiURL = URL(string:"https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVINValuesBatch/")!
        
        //Returns an object containing the current user's information
        let user = Auth.auth().currentUser
        
        if let user = user {
            
            //Return's the current user's unique ID
            self.uid = user.uid
        }
        if (self.vin == nil){
            
            self.getVIN()

        } else {
            self.vinLabel.text = self.vin
            self.getVehicleInfo()
            LoadingHud.hideHud(self.view)
        }
        LoadingHud.hideHud(self.view)
        subscribeToCodeEvents()
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    @IBAction func codeHistory(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "codeHistorySegue", sender: self)
        }
    }
    
    @IBAction func readCodes(_ sender: UIButton) {
        //        LoadingHud.showHud(self.view, label: "Reading codes...")
        
        var task = self.deviceInfo!.callFunction("readCodes", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                //Completed Successfully
            } else {
                print("Error: ", error)
            }
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "readCodesSegue", sender: self)
        }
    }
    
    @IBAction func clearCodes(_ sender: Any) {
        
        LoadingHud.showHud(self.view, label: "Clearing codes...")
        var task = self.deviceInfo!.callFunction("clearCodes", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                LoadingHud.hideHud(self.view)
                
                self.dialog = ZAlertView(title: "Codes Cleared",
                                         message: "Trouble codes were successfully cleared from the vehicle!",
                                         closeButtonText: "OK",
                                         closeButtonHandler: { (alertView) -> () in
                                            alertView.dismissAlertView()
                })
                self.dialog.allowTouchOutsideToDismiss = false
                self.dialog.show()
                
            } else{
                LoadingHud.hideHud(self.view)
                
                self.dialog = ZAlertView(title: "Codes Not Cleared",
                                         message: "The code-clearing operation was unsuccessful! See error message below.\n \(error?.localizedDescription ?? "")",
                    closeButtonText: "OK",
                    closeButtonHandler: { (alertView) -> () in
                        alertView.dismissAlertView()
                })
                self.dialog.allowTouchOutsideToDismiss = false
                self.dialog.show()
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
}

extension MainMenuViewController {
    //returns a string of the current date and time
    func getDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy-hh:mm"
        return dateFormatter.string(from: date)
    }
    
    func getVIN(){
        var task = self.deviceInfo!.callFunction("readVIN", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                //Completed Successfully
            } else {
                print("Could not get VIN!!")
                
//              Comment to use with device, hardcoded to use while testing
//                self.vinLabel.text = "2G1FE1ED7B9118397"
            }
        }
        LoadingHud.showHud(self.view, label: "Loading Data...")
        self.handler = ParticleCloud.sharedInstance().subscribeToAllEvents(withPrefix: "vin/result", handler: { (event :ParticleEvent?, error : Error?) in
            if let _ = error {
                print ("Could not subscribe to readVIN Event")
                LoadingHud.hideHud(self.view)
            } else {
                DispatchQueue.main.async(execute: {
                    self.ref.child("users").child(self.uid).child("vehicles").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if snapshot.hasChild(event?.data?.description as! String){
                            print("Vehicle exists in database!")
                            self.vin = event?.data?.description as! String
                            self.vinLabel.text = event?.data?.description as! String
                            self.getVehicleInfo()
                            LoadingHud.hideHud(self.view)
                        } else {
                            self.pushVehicleInfo(vin: event?.data?.description as! String)
                            self.vin = event?.data?.description as! String
                            self.vinLabel.text = event?.data?.description as! String
                            self.getVehicleInfo()
                            LoadingHud.hideHud(self.view)
                        }
                    })
                })
            }
        })
    }
    
    func pushVehicleInfo(vin: String) -> Void {
        
        var vehicle: VinRequest!
        self.parameters = [
            "data":"\(vin);",
            "format":"json"
        ]
        
        VinRequest.request(URL: apiURL, method: .post, parameters: self.parameters).then {
            apiData in VinRequest.saveJSON(value: apiData, vinPath: self.vinPath)
            }.then{ stuff -> Void in
                self.vehicleData = VinRequest.getJSON(vinPath: self.vinPath)
                vehicle = VinRequest(vehicle: self.vehicleData)
                self.yMMLabel.text = "\(vehicle.getVehicleYear()) \(vehicle.getVehicleMake()) \(vehicle.getVehicleModel())"
                self.vehicleStruct = Vehicle(vin: vehicle.getVehicleVIN() ?? "vin", year: vehicle.getVehicleYear() ?? "year", make: vehicle.getVehicleMake() ?? "make", model: vehicle.getVehicleModel() ?? "model")
                self.ref.child("users").child(self.uid).child("vehicles").child(vin).child("vehicle year").setValue(vehicle.getVehicleYear())
                self.ref.child("users").child(self.uid).child("vehicles").child(vin).child("vehicle make").setValue(vehicle.getVehicleMake())
                self.ref.child("users").child(self.uid).child("vehicles").child(vin).child("vehicle model").setValue(vehicle.getVehicleModel())
                self.ref.child("users").child(self.uid).child("vehicles").child(vin).child("vehicle engine").setValue(vehicle.getVehicleEngineSize())
                self.ref.child("users").child(self.uid).child("vehicles").child(vin).child("vehicle type").setValue(vehicle.getVehicleType())
                self.ref.child("users").child(self.uid).child("vehicles").child(vin).child("vehicle drive type").setValue(vehicle.getVehicleDriveType())
                self.ref.child("users").child(self.uid).child("vehicles").child(vin).child("vehicle transmission").setValue(vehicle.getVehicleTransmission())
                self.ref.child("users").child(self.uid).child("vehicles").child(vin).child("vehicle fuel type").setValue(vehicle.getVehicleFuelType())
                self.ref.child("users").child(self.uid).child("vehicles").child(vin).child("vehicle assembly plant").setValue(vehicle.getVehicleAssemblyPlant())
                
            } .catch { error in
                print(error)
        }
    }
    
    func getVehicleInfo(){
        
        //        LoadingHud.show(self.view, label: "Loading Data...")
        self.ref.child("users").child(self.uid).child("vehicles").child(self.vin).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.yMMLabel.text = "\(value?["vehicle year"] as? String ?? "") \(value?["vehicle make"] as? String ?? "") \(value?["vehicle model"] as? String ?? "")".uppercased()
            self.vehicleStruct = Vehicle(vin: self.vin, year: value?["vehicle year"] as? String ?? "year", make: value?["vehicle make"] as? String ?? "make", model: value?["vehicle model"] as? String ?? "model")
            self.vehicleImage.contentMode = UIViewContentMode.scaleAspectFit
            self.vehicleImage.clipsToBounds = true
            self.vehicleImage.image = UIImage(named: "camaro")
//            LoadingHud.hideHud(self.view)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func subscribeToCodeEvents(){
//        var thisVin = self.vinLabel.text!
        
        self.handler = self.deviceInfo!.subscribeToEvents(withPrefix: "codes/result", handler: { (event :ParticleEvent?, error : Error?) in
            if let _ = error {
                print ("Error: ", error)
                //                readCodes(_ sender: self)
            } else {
                print("Completed particle event subscription, now loading codes...")
                self.dateString = self.getDate();
                
                //put codes into an array
                var codesArr : [String] = (event?.data?.components(separatedBy: ","))!
                /*
                 filters the 'p', 'c' of 's' out of the code and add the corresponding
                 "Pending", "Current" or "Stored" to the beginning of the code description.
                 
                 Then stores this code under the vehicle document as a child its respective status
                 */
                for s in codesArr {
                    
                    var code = s
                    var description = ""
                    var child: String!
                    
                    //filter the letter out of the code
                    if let i = code.characters.index(of:"p") {
                        child = "Pending"
                        code.remove(at: i)
                        description = "Pending: "
                    }
                    if let i = code.characters.index(of:"c") {
                        child = "Cleared"
                        code.remove(at: i)
                        description = "Cleared: "
                    }
                    if let i = code.characters.index(of:"s") {
                        child = "Current"
                        code.remove(at:i)
                        description = "Current: "
                    }
                    
                    //find code descriptions in firebase and add them to the description variable
                    self.ref.child("trouble-codes").child(code).observeSingleEvent(of: .value, with: { (snapshot) in
                        description += (snapshot.value as? NSString)! as String
                        
                        //push the codes and their descriptions to firebase under the respective vehicle
                        self.ref.child("users").child(self.uid).child("vehicles").child(self.vinLabel.text!).child("storedCodes").child(self.dateString).child(child).child(code).setValue(description)
                    })
                }
            self.ref.child("users").child(self.uid).child("vehicles").child(self.vinLabel.text!).child("storedCodes").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild(self.dateString){
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "readCodesSegue", sender: self)
                        }
                    }
                })
            }//end else
        })//end handler
    }//end func subscribeToCodeEvents()
}
