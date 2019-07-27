//
//  UIView+Utils.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit
import SCLAlertView

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
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showClasicAlert(title: String, message: String) {
        // show error
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    func showMessage(title: String, message: String) {
        // show message
        SCLAlertView().showNotice(title, subTitle: message) // Notice
    }
    
    func showInfo(title: String, message: String) {
        // show info message
        SCLAlertView().showInfo(title, subTitle: message) // Info
    }
    
    func showError(title: String, message: String) {
        // show message
        SCLAlertView().showError(title, subTitle: message) // Notice
    }
}
