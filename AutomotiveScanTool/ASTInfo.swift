//
//  ASTInfo.swift
//  AutomotiveScanTool
//
//  Created by James Hall on 11/18/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import Foundation
import UIKit
import ParticleSDK


class ASTInfo {
    
    //Function that
    class func getDeviceTypeAndImage(_ device : ParticleDevice?) -> (deviceType: String, deviceImage: UIImage) {
        
        var image : UIImage?
        var text : String?
        
        switch (device!.type)
        {
        case .core:
            image = UIImage(named: "imgDeviceCore")
            text = "Core"
            
        case .electron:
            image = UIImage(named: "imgDeviceElectron")
            text = "Electron"
            
        case .photon:
            image = UIImage(named: "imgDevicePhoton")
            text = "Photon/P0"

        case .P1:
            image = UIImage(named: "imgDeviceP1")
            text = "P1"

        case .raspberryPi:
            image = UIImage(named: "imgDeviceRaspberryPi")
            text = "Raspberry Pi"

        case .redBearDuo:
            image = UIImage(named: "imgDeviceRedBearDuo")
            text = "RedBear Duo"

        case .bluz:
            image = UIImage(named: "imgDeviceBluz")
            text = "Bluz"

        case .digistumpOak:
            image = UIImage(named: "imgDeviceDigistumpOak")
            text = "Digistump Oak"
            
        default:
            image = UIImage(named: "imgDeviceUnknown")
            text = "Unknown"
            
        }
        
        return (text!, image!)
    }
}
