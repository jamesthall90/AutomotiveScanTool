//
//  Vehicle.swift
//  AutomotiveScanTool
//
//  Created by James Hall on 12/4/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import Foundation

struct Vehicle {
    
    var vin: String?
    var year: String?
    var make: String?
    var model: String?
    
    init(vin: String?, year: String?, make: String?, model: String?){
        self.vin = vin
        self.year = year
        self.make = make
        self.model = model
    }
}
