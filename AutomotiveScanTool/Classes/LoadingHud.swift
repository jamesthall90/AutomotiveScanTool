//
//  VInfoViewController.swift
//  AST
//
//  Created by James Hall on 10/22/17.
//  Copyright © 2017 OP. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

@objc open class LoadingHud : NSObject {
    
    class func showHud(_ view : UIView, label: String) {
        
        var hud : MBProgressHUD
        
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.animationType = .zoomIn
        hud.label.text = label
        hud.label.textColor = UIColor.white
        hud.minShowTime = 1
        hud.color = UIColor.clear
        hud.contentColor = UIColor.blue
        hud.backgroundView.color = UIColor.white
    }
    
    class func hideHud(_ view : UIView) {
        
        MBProgressHUD.hide(for: view, animated: true)
    }
}

