//
//  CustomSegue.swift
//  AutomotiveScanTool
//
//  Created by James Hall on 11/13/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import UIKit
import Hero

class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
        
        if let identifier = self.identifier {
            
//            switch identifier{
//
//            case "idSeguePresentMainMenu":
//
//                    //Sets the segue's destination VC
//                    let dest = self.destination as! MainMenuViewController
//
//                    //Sets the segue's source VC
//                    let source = self.source as! DeviceViewController
//
//                    //Passes the selected device to the destination VC
//                    if let deviceObject = source.particleDevices?[source.selectedDeviceIndex] {
//
//                        dest.deviceInfo = deviceObject
//
//                    } else {
//                        //handle the case of 'deviceObject' being 'nil'
//                    }
//
//                    //Enables Hero animations for the destination VC
//                    dest.isHeroEnabled = true
//
//                    //Sets the animation type for the segue
//                    dest.heroModalAnimationType = .zoomSlide(direction: HeroDefaultAnimationType.Direction.left)
//
//                    //Performs the segue
//                    source.hero_replaceViewController(with: dest)
//
//            case "presentDeviceList":
//
//                //Sets the segue's destination VC
//                let dest = self.destination as! DeviceViewController
//
//                //Sets the segue's source VC
//                let source = self.source as! MainMenuViewController
//
//                //Enables Hero animations for the destination VC
//                dest.isHeroEnabled = true
//
//                //Sets the animation type for the segue
//                dest.heroModalAnimationType = .zoomSlide(direction: HeroDefaultAnimationType.Direction.right)
//
//                //Performs the segue
//                source.hero_replaceViewController(with: dest)
//
//            case "logoutSegue":
//
//                //Sets the segue's destination VC
//                let dest = self.destination as! LoginViewController
//
//                //Sets the segue's source VC
//                let source = self.source as! DeviceViewController
//
//                //Enables Hero animations for the destination VC
//                dest.isHeroEnabled = true
//
//                //Sets the animation type for the segue
//                dest.heroModalAnimationType = .zoomOut
//
//                source.hero_replaceViewController(with: dest)
//
//            case "vInfoSegue":
//
//                //Sets the segue's destination VC
//                let dest = self.destination as! VInfoViewController
//
//                //Sets the segue's source VC
//                let source = self.source as! MainMenuViewController
//
//                if source.ref != nil{
//
//                    dest.uid = source.uid
//                    dest.ref = source.ref
//                    dest.vin = source.vinLabel.text
//                    dest.deviceInfo = source.deviceInfo
//                    dest.newImage = source.vehicleImage.image
//
//                } else {
//
//                    print("Database reference is nil!")
//                }
//
//                //Enables Hero animations for the destination VC
//                dest.isHeroEnabled = true
//
//                //Sets the animation type for the segue
//                dest.heroModalAnimationType = .zoom
//
//                //Performs the segue
//                source.hero_replaceViewController(with: dest)
//
//            case "vIBackSegue":
//
//                    //Sets the segue's destination VC
//                    let dest = self.destination as! MainMenuViewController
//
//                    //Sets the segue's source VC
//                    let source = self.source as! VInfoViewController
//
//                    if source.ref != nil{
//
//                        dest.uid = source.uid
//                        dest.ref = source.ref
//                        dest.vin = source.vin
//                        dest.deviceInfo = source.deviceInfo
//
//                    } else {
//
//                        print("Database reference is nil!")
//                    }
//                    //Enables Hero animations for the destination VC
//                    dest.isHeroEnabled = true
//
//                    //Sets the animation type for the segue
//                    dest.heroModalAnimationType = .zoom
//
//                    //Performs the segue
//                    source.hero_replaceViewController(with: dest)
//
//            case "deviceSelectSegue":
//
//                //Sets the segue's destination VC
//                let dest = self.destination as! DeviceViewController
//
//                //Sets the segue's source VC
//                let source = self.source as! LoginViewController
//
//                //Enables Hero animations for the destination VC
//                dest.isHeroEnabled = true
//
//                //Sets the animation type for the segue
//                dest.heroModalAnimationType = .zoom
//
//                //Performs the segue
//                source.hero_replaceViewController(with: dest)
//
//            case "readCodesSegue":
//
//                    //Sets the segue's destination VC
//                    //                let dest = self.destination as! ReadCodesViewController
//                    let dest = self.destination as! RCViewController
//
//                    //Sets the segue's source VC
//                    let source = self.source as! MainMenuViewController
//
//                    if source.ref != nil{
//
//                        dest.uid = source.uid
//                        dest.ref = source.ref
//                        dest.vin = source.vinLabel.text
//                        dest.dateString = source.dateString
//
//                    } else {
//
//                        print("Database reference is nil!")
//                    }
//
//                    //Enables Hero animations for the destination VC
//                    dest.isHeroEnabled = true
//
//                    //Sets the animation type for the segue
//                    dest.heroModalAnimationType = .zoom
//
//                    //Performs the segue
//                    source.hero_replaceViewController(with: dest)
//            default:
//                print("No segue identifier provided.")
//
//            }
            
            if identifier == "idSeguePresentMainMenu" {

                //Sets the segue's destination VC
                let dest = self.destination as! MainMenuViewController

                //Sets the segue's source VC
                let source = self.source as! DeviceViewController

                //Passes the selected device to the destination VC
                if let deviceObject = source.particleDevices?[source.selectedDeviceIndex] {

                    dest.deviceInfo = deviceObject

                } else {
                    //handle the case of 'deviceObject' being 'nil'
                }

                //Enables Hero animations for the destination VC
                dest.isHeroEnabled = true

                //Sets the animation type for the segue
                dest.heroModalAnimationType = .zoomSlide(direction: HeroDefaultAnimationType.Direction.left)

                //Performs the segue
                source.hero_replaceViewController(with: dest)
            }
            else if identifier == "presentDeviceList" {

                //Sets the segue's destination VC
                let dest = self.destination as! DeviceViewController

                //Sets the segue's source VC
                let source = self.source as! MainMenuViewController

                //Enables Hero animations for the destination VC
                dest.isHeroEnabled = true

                //Sets the animation type for the segue
                dest.heroModalAnimationType = .zoomSlide(direction: HeroDefaultAnimationType.Direction.right)

                //Performs the segue
                source.hero_replaceViewController(with: dest)
            }
            else if identifier == "logoutSegue" {

                //Sets the segue's destination VC
                let dest = self.destination as! LoginViewController

                //Sets the segue's source VC
                let source = self.source as! DeviceViewController

                //Enables Hero animations for the destination VC
                dest.isHeroEnabled = true

                //Sets the animation type for the segue
                dest.heroModalAnimationType = .zoomOut

                source.hero_replaceViewController(with: dest)
            }
            else if identifier == "vInfoSegue" {

                //Sets the segue's destination VC
                let dest = self.destination as! VInfoViewController

                //Sets the segue's source VC
                let source = self.source as! MainMenuViewController

                if source.ref != nil{

                    dest.uid = source.uid
                    dest.ref = source.ref
                    dest.vin = source.vinLabel.text
                    dest.deviceInfo = source.deviceInfo
                    dest.newImage = source.vehicleImage.image

                } else {

                    print("Database reference is nil!")
                }

                //Enables Hero animations for the destination VC
                dest.isHeroEnabled = true

                //Sets the animation type for the segue
                dest.heroModalAnimationType = .zoom

                //Performs the segue
                source.hero_replaceViewController(with: dest)
            }
            else if identifier == "vIBackSegue" {

                //Sets the segue's destination VC
                let dest = self.destination as! MainMenuViewController

                //Sets the segue's source VC
                let source = self.source as! VInfoViewController

                if source.ref != nil{

                    dest.uid = source.uid
                    dest.ref = source.ref
                    dest.vin = source.vin
                    dest.deviceInfo = source.deviceInfo

                } else {

                    print("Database reference is nil!")
                }

                //Enables Hero animations for the destination VC
                dest.isHeroEnabled = true

                //Sets the animation type for the segue
                dest.heroModalAnimationType = .zoom

                //Performs the segue
                source.hero_replaceViewController(with: dest)
            }
            else if identifier == "deviceSelectSegue" {

                //Sets the segue's destination VC
                let dest = self.destination as! DeviceViewController

                //Sets the segue's source VC
                let source = self.source as! LoginViewController

                //Enables Hero animations for the destination VC
                dest.isHeroEnabled = true

                //Sets the animation type for the segue
                dest.heroModalAnimationType = .zoom

                //Performs the segue
                source.hero_replaceViewController(with: dest)
            }
            else if identifier == "readCodesSegue" {
                
                //Sets the segue's destination VC
//                let dest = self.destination as! ReadCodesViewController
                let dest = self.destination as! ReadCodesViewController
                
                //Sets the segue's source VC
                let source = self.source as! MainMenuViewController
                
                if source.ref != nil{
                    
                    dest.uid = source.uid
                    dest.ref = source.ref
                    dest.vin = source.vinLabel.text
                    dest.dateString = source.dateString
                    dest.deviceInfo = source.deviceInfo
                    
                } else {
                    
                    print("Database reference is nil!")
                }
                
                //Enables Hero animations for the destination VC
                dest.isHeroEnabled = true
                
                //Sets the animation type for the segue
                dest.heroModalAnimationType = .zoom
                
                //Performs the segue
                source.hero_replaceViewController(with: dest)
            }
            else if identifier == "troubleCodeBackSegue" {
                
                //Sets the segue's destination VC
                let dest = self.destination as! MainMenuViewController
                
                //Sets the segue's source VC
                let source = self.source as! RCViewController
                
                if source.ref != nil{
                    
                    dest.uid = source.uid
                    dest.ref = source.ref
                    dest.vinLabel?.text = source.vin
                    dest.dateString = source.dateString
                    dest.deviceInfo = source.deviceInfo
                    
                } else {
                    
                    print("Database reference is nil!")
                }
                
                //Enables Hero animations for the destination VC
                dest.isHeroEnabled = true
                
                //Sets the animation type for the segue
                dest.heroModalAnimationType = .zoom
                
                //Performs the segue
                source.hero_replaceViewController(with: dest)
            }
        }
    }
}
