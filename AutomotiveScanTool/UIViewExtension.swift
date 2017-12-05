//
//  UIViewExtension.swift
//  AST
//
//  Created by James Hall on 10/4/17.
//  Copyright © 2017 OP. All rights reserved.
//
import UIKit

//
// Inspectable - Design and layout for View
// cornerRadius, borderWidth, borderColor
//
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: CGColor? {
        get{
            return layer.shadowColor
        }
        set{
            layer.shadowColor = newValue
        }
    }
    
}

// View for UILabel Accessory
extension UIView {
    
    func rightValidAccessoryView() -> UIView {
        let imgView = UIImageView(image: UIImage(named: "check_valid"))
        imgView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imgView.backgroundColor = UIColor.clear
        return imgView
    }
    
    func rightInValidAccessoryView() -> UIView {
        let imgView = UIImageView(image: UIImage(named: "check_invalid"))
        imgView.frame = CGRect(x: self.cornerRadius, y: self.cornerRadius, width: 20, height: 20)
        imgView.backgroundColor = UIColor.clear
        return imgView
    }
}

struct CustomProperties {
    static var indexer: IndexPath = IndexPath()
}

extension UIButton {
    
    var indexer: IndexPath {
        get {
            return objc_getAssociatedObject(CustomProperties.indexer, &CustomProperties.indexer) as! IndexPath
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.indexer, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
