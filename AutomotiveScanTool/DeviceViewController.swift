//
//  DeviceViewController.swift
//  AST
//
//  Created by James Hall on 10/14/17.
//  Copyright © 2017 OP. All rights reserved.
//

import UIKit
import ParticleSDK
import FirebaseAuth
import QuartzCore


let kDefaultCoreFlashingTime : Int = 30
let kDefaultPhotonFlashingTime : Int = 15
let kDefaultElectronFlashingTime : Int = 15

class DeviceViewController: UIViewController{

    @IBOutlet weak var deviceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


