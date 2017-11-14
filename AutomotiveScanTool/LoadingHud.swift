//
//  ParticleSpinner.swift
//  Particle
//
//  Created by Ido Kleinman on 6/24/16.
//  Copyright © 2016 spark. All rights reserved.
//
import Foundation
import UIKit
import MBProgressHUD

@objc open class LoadingHud : NSObject {
    
    class func show(_ view : UIView, label: String) {
        var hud : MBProgressHUD
        
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.animationType = .zoomIn
        hud.label.text = label
        hud.label.textColor = UIColor.white
        hud.minShowTime = 1
        
        if label == "Logging In..."{
            
            hud.color = UIColor.clear
            hud.contentColor = UIColor.blue
        
        } else {
            hud.color = UIColor.darkGray
            hud.contentColor = UIColor.white
        }
    }
    
    class func hide(_ view : UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
}

