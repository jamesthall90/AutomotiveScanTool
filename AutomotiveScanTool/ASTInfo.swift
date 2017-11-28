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
    
    class func animateOnlineIndicatorImageView(_ imageView: UIImageView, online: Bool, flashing: Bool) {
        DispatchQueue.main.async(execute: {
            imageView.image = UIImage(named: "imgCircle")
            //
            
            imageView.image = imageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            
            if flashing {
                imageView.tintColor = UIColor(red: 239.0/255.0, green: 13.0/255.0, blue: 209.0/255.0, alpha: 1.0) // Flashing purple
                imageView.alpha = 1
                UIView.animate(withDuration: 0.12, delay: 0, options: [.autoreverse, .repeat], animations: {
                    imageView.alpha = 0
                }, completion: nil)
                
            } else if online {
                imageView.tintColor = UIColor(red: 0, green: 173.0/255.0, blue: 239.0/255.0, alpha: 1.0) // ParticleCyan
                
                if imageView.alpha == 1 {
                    //                    print ("1-->0")
                    UIView.animate(withDuration: 2.5, delay: 0, options: [.autoreverse, .repeat], animations: {
                        imageView.alpha = 0.15
                    }, completion: nil)
                } else {
                    //                    print ("0-->1")
                    imageView.alpha = 0.15
                    UIView.animate(withDuration: 2.5, delay: 0, options: [.autoreverse, .repeat], animations: {
                        imageView.alpha = 1
                    }, completion: nil)
                    
                }
            } else {
                imageView.tintColor = UIColor(white: 0.466, alpha: 1.0) // ParticleGray
                imageView.alpha = 1
                imageView.layer.removeAllAnimations()
            }
        })
    }
    
    class func getDeviceState(_ device : ParticleDevice?) -> String {
        
        let state = device?.connected
        
        switch state! {
            
        case true:
            return "Connected"
            
        default:
            return "Not Connected"
        }
    }
    
}
