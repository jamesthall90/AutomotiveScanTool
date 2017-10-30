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


class DeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ParticleDeviceDelegate {
    
    //define this function to decide what happens when a row is selected
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //determines the number of rows that will be in the tableview
        //currently hardcoded because i cant figure out how to get this to be dynamic
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //default cell style
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "device_cell");
        
        //getDevices call for the particleSDK
        ParticleCloud.sharedInstance().getDevices{ (particleDevices:[ParticleDevice]?, error:Error?) -> Void in
            if let _ = error {
                print("Check internet connectivity");
            } else {
                if let devices = particleDevices {
                    //set the text label of the current cell to the corresponding device name in no particular order
                    cell.textLabel?.text = devices[indexPath.row].name;
                }
            }
        }
        
        return cell
    }
    

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


