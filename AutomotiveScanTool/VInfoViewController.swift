//
//  VInfoViewController.swift
//  AST
//
//  Created by James Hall on 10/22/17.
//  Copyright © 2017 OP. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ParticleSDK

class VInfoViewController: UIViewController {

    var uid: String!
    var ref: DatabaseReference!
    var deviceInfo: ParticleDevice!
    @IBOutlet weak var vIYearLabel: UILabel!
    @IBOutlet weak var vIMakeLabel: UILabel!
    @IBOutlet weak var vIModelLabel: UILabel!
    @IBOutlet weak var vIVINLabel: UILabel!
    @IBOutlet weak var vIEngineLabel: UILabel!
    @IBOutlet weak var vIDriveTypeLabel: UILabel!
    @IBOutlet weak var vITransmissionLabel: UILabel!
    @IBOutlet weak var vIAssyPlantLabel: UILabel!
    @IBOutlet weak var vIFuelTypeLabel: UILabel!
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var yearTitle: UILabel!
    @IBOutlet weak var makeTitle: UILabel!
    @IBOutlet weak var modelTitle: UILabel!
    @IBOutlet weak var vinTitle: UILabel!
    @IBOutlet weak var engineTitle: UILabel!
    @IBOutlet weak var dTTitle: UILabel!
    @IBOutlet weak var transTitle: UILabel!
    @IBOutlet weak var aPlantTitle: UILabel!
    @IBOutlet weak var fuelTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func vIBackButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "vIBackSegue", sender: self)
    }
    
    func fillLabels(){
        
        LoadingHud.showHud(self.view, label: "Loading Data...")
        
        var task = self.deviceInfo!.callFunction("readVIN", withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Performed readVin() function with no errors!")
            }
        }
        
        var handler = ParticleCloud.sharedInstance().subscribeToAllEvents(withPrefix: "vin/result", handler: { (event :ParticleEvent?, error : Error?) in
            if let _ = error {
                
                print ("Could not subscribe to readVIN Event")
                
            } else {
                
                DispatchQueue.main.async(execute: {
                    
                    self.ref.child("users").child(self.uid).child("vehicles").child(event?.data?.description as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                            let value = snapshot.value as? NSDictionary
                            self.vIVINLabel.text = event?.data?.description as! String
                            self.vIYearLabel.text = value?["vehicle year"] as? String ?? ""
                            self.vIMakeLabel.text = value?["vehicle make"] as? String ?? ""
                            self.vIModelLabel.text = value?["vehicle model"] as? String ?? ""
                            self.vIEngineLabel.text = value?["vehicle engine"] as? String ?? ""
                            self.vIDriveTypeLabel.text = value?["vehicle drive type"] as? String ?? ""
                            self.vITransmissionLabel.text = value?["vehicle transmission"] as? String ?? ""
                            self.vIAssyPlantLabel.text = value?["vehicle assembly plant"] as? String ?? ""
                            self.vIFuelTypeLabel.text = value?["vehicle fuel type"] as? String ?? ""
                        
                            self.yearTitle.text = "Year"
                            self.makeTitle.text = "Make"
                            self.modelTitle.text = "Model"
                            self.vinTitle.text = "VIN"
                            self.engineTitle.text = "Engine"
                            self.dTTitle.text = "Drive Type"
                            self.transTitle.text = "Transmission"
                            self.aPlantTitle.text = "Assy. Plant"
                            self.fuelTitle.text = "Fuel Type"
                        
                            LoadingHud.hideHud(self.view)
                        
                        }) { (error) in
                            
                            print(error.localizedDescription)
                        }
                })
            }
        })
    }
}
