//
//  VInfoViewController.swift
//  AST
//
//  Created by James Hall on 10/22/17.
//  Copyright © 2017 OP. All rights reserved.
//

import UIKit

class VInfoViewController: UIViewController {

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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func vIBackButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "vIBackSegue", sender: self)
    }
}
