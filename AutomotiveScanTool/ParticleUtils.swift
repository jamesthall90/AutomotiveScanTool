//
//  ParticleUtils.swift
//  Particle
//
//  Created by Ido Kleinman on 6/29/16.
//  Copyright © 2016 spark. All rights reserved.
//
import Foundation
import UIKit
import ParticleSDK

class ParticleUtils: NSObject {
    
    static var particleCyanColor = UIColor(red:0.00, green:0.68, blue:0.94, alpha:1.0)
    static var particleAlmostWhiteColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
    static var particleDarkGrayColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
    static var particleGrayColor = UIColor(red:0.47, green:0.47, blue:0.47, alpha:1.0)
    static var particleLightGrayColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
    static var particlePomegranateColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
    static var particleEmeraldColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
    static var particleRegularFont = UIFont(name: "Gotham-book", size: 16.0)!
    static var particleBoldFont = UIFont(name: "Gotham-medium", size: 16.0)!
    
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
    
    
    class func shouldDisplayTutorialForViewController(_ vc : UIViewController) -> Bool {
        
        //        return true
        /// debug
        
        let prefs = UserDefaults.standard
        let defaultsKeyName = "Tutorial"
        let dictKeyName = String(describing: type(of: vc))
        
        if let onceDict = prefs.dictionary(forKey: defaultsKeyName) {
            let keyExists = onceDict[dictKeyName] != nil
            if keyExists {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    
    class func setTutorialWasDisplayedForViewController(_ vc : UIViewController) {
        
        let prefs = UserDefaults.standard
        let defaultsKeyName = "Tutorial"
        let dictKeyName = String(describing: type(of: vc))
        
        if var onceDict = prefs.dictionary(forKey: defaultsKeyName) {
            onceDict[dictKeyName] = true
            prefs.set(onceDict, forKey: defaultsKeyName)
        } else {
            prefs.set([dictKeyName : true], forKey: defaultsKeyName)
        }
    }
    
    class func resetTutorialWasDisplayed() {
        
        let prefs = UserDefaults.standard
        let keyName = "Tutorial"
        prefs.removeObject(forKey: keyName)
        
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
    
}

