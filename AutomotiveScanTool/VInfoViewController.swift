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
    var vin: String!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "vIBackSegue" {
                let mMenu = segue.destination as! MainMenuViewController
                
                if ref != nil{
                    
                    mMenu.uid = self.uid
                    mMenu.ref = self.ref
                    mMenu.vin = self.vin
                    mMenu.deviceInfo = self.deviceInfo
                    
                } else {
                    
                    print("Database reference is nil!")
                }
            }
        }
    }
    
    @IBAction func vIBackButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "vIBackSegue", sender: self)
    }
    
    func fillLabels(){
        
        self.vIVINLabel.text = vin
        
        self.ref.child("users").child(self.uid).child("vehicles").child(self.vin).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            self.vIYearLabel.text = value?["vehicle year"] as? String ?? ""
            self.vIMakeLabel.text = value?["vehicle make"] as? String ?? ""
            self.vIModelLabel.text = value?["vehicle model"] as? String ?? ""
            self.vIEngineLabel.text = value?["vehicle engine"] as? String ?? ""
            self.vIDriveTypeLabel.text = value?["vehicle drive type"] as? String ?? ""
            self.vITransmissionLabel.text = value?["vehicle transmission"] as? String ?? ""
            self.vIAssyPlantLabel.text = value?["vehicle assembly plant"] as? String ?? ""
            self.vIFuelTypeLabel.text = value?["vehicle fuel type"] as? String ?? ""
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
