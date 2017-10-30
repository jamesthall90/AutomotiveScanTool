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

class ViewController: UIViewController {

    @IBOutlet weak var yMMLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vehicle = VinRequest(VIN:"3GNFK16T5YG164967")
        
        yMMLabel.text = "\(vehicle.getVehicleYear())  \(vehicle.getVehicleMake()) \(vehicle.getVehicleModel())"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
     }
    
    @IBAction func clearCodes(_ sender: Any) {
        
      
    }
    
    @IBAction func vIButton(_ sender: Any) {
        
        //Segue's to Main Menu view
        self.performSegue(withIdentifier: "vISegue", sender: self)
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
}
