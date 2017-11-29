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
import AwaitKit
import SwiftyJSON
import ZAlertView
import Alamofire

class MainMenuViewController: UIViewController {
    
    var handler: Any?
    var deviceInfo: ParticleDevice!
    var vehicle: VinRequest!
    var ref: DatabaseReference!
    var uid: String!
    var vin: String!
    var dateString: String!
    var parameters: Parameters?
    var apiURL: URL!
    var vinPath: String!
    var vehicleData: JSON!
    var dialog: ZAlertView!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var yMMLabel: UILabel!
    @IBOutlet weak var vinLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            //            if let sid = self.handler {
            //                print("*^&%&$*")
            //                ParticleCloud.sharedInstance().unsubscribeFromEvent(withID: sid)
            //            }
        } else {
            self.vinLabel.text = self.vin
            self.getVehicleInfo()
            LoadingHud.hideHud(self.view)
        }
        LoadingHud.hideHud(self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func codeHistory(_ sender: UIButton) {
        
        
    }
    
    @IBAction func readCodes(_ sender: UIButton) {
//        LoadingHud.showHud(self.view, label: "Reading codes...")
        dateString = getDate();
        
//        var task = self.deviceInfo!.callFunction("readCodes", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
//            if (error == nil) {
//                //testing line
//                print("Performed readCodes() function with no errors!")
//                let json = JSON(resultCode)
//                print("Json item: ", json)
//            } else {
//                print("Error: ", error)
//            }
//        }
        
        self.handler = ParticleCloud.sharedInstance().subscribeToAllEvents(withPrefix: "codes/result", handler: { (event :ParticleEvent?, error : Error?) in
            if let _ = error {
                print ("Error: ", error)
//                readCodes(_ sender: self)
            } else {
                print("Completed particle event subscription, now loading codes...")
                DispatchQueue.main.async(execute: {
                    //testing line
//                     print("got event with data \(event?.data?.description as! String)")
                    
                
                    //put codes into an array
                    var codesArr : [String] = (event?.data?.components(separatedBy: ","))!
                    print("******************************************")
                    print("Codes Array: " , codesArr)
                    
                    if codesArr[0] == "null"{
                        
                        self.dialog = ZAlertView(title: "No Codes!",
                                                 message: "Vehicle has no trouble codes present!",
                                                 closeButtonText: "OK",
                                                 closeButtonHandler: { (alertView) -> () in
                                                    alertView.dismissAlertView()
                        })
                        
                        self.dialog.allowTouchOutsideToDismiss = false
                        
                        self.dialog.show()
                        
                        LoadingHud.hideHud(self.view)
                        
                    } else {
                        /*
                         filters the 'p' or 'c' out of the code and add the corresponding
                         "pending" or "current" to the beginning of the code description.
                         
                         Then stores this code under the vehicle document as a child of the date and time
                         
                         there is a problem with this when there is more than one code with multiple suffixes
                         ie: s, p and c because only the last suffix will be stored as the description since
                         the key wil be overwritten with the new value so best version of the code will not
                         be stored. Need to fix this
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
                                
                                //testing line
                                print("Code is: \(code)  Description is: \(description) Vin is: \(self.vinLabel.text)")
                                
                                //push the codes and their descriptions to firebase under the respective vehicle
//                                self.ref.child("users").child(self.uid).child("vehicles").child(self.vinLabel.text!).child("storedCodes").child(self.dateString).child(code).setValue(description)
                            self.ref.child("users").child(self.uid).child("vehicles").child(self.vinLabel.text!).child("storedCodes").child(self.dateString).child(child).child(code).setValue(description)
                            })
                        }
//                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "readCodesSegue", sender: self)
//                        }
                    }//end else
                
                }) //end DispatchQueue
            }//end else
        })//end handler
        
        var task = self.deviceInfo!.callFunction("readCodes", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                
                //testing line
                print("Performed readCodes() function with no errors!")
            
            } else {
                print("Error: ", error)
            }
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
                print("Performed readVin() function with no errors!")
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
                print("******************************************")
                print("Codes Array: " , codesArr)
                
                /*
                 filters the 'p' or 'c' out of the code and add the corresponding
                 "pending" or "current" to the beginning of the code description.
                 
                 Then stores this code under the vehicle document as a child of the date and time
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
                        
                        //testing line
                        print("Code is: \(code)  Description is: \(description) Vin is: \(self.vinLabel.text)")
                        
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
    }
}
