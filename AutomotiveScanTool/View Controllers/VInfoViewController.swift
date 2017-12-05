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
import Font_Awesome_Swift

class VInfoViewController: UIViewController {

    var uid: String!
    var vin: String!
    var ref: DatabaseReference!
    var deviceInfo: ParticleDevice!
    var newImage: UIImage!
    var vehicleStruct: Vehicle?
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
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButtonOutlet.setFAIcon(icon: .FAChevronLeft, iconSize: 25, forState: .normal)
        
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
        
            self.imageView.contentMode = UIViewContentMode.scaleAspectFit
            self.imageView.clipsToBounds = true
            self.imageView.image = newImage
        
            self.ref.child("users").child(self.uid).child("vehicles").child(self.vin as!
                String).observeSingleEvent(of: .value, with: { (snapshot) in
                
                    let value = snapshot.value as? NSDictionary
                    self.vIVINLabel.text = self.vin
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
            })
    }
}
