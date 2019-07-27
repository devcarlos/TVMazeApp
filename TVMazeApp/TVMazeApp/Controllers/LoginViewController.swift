//
//  LoginViewController.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/27/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var isTouchEnabled:Bool = false
    var userPIN = ""
    
    var context = LAContext()
    
    enum AuthenticationState {
        case loggedin, loggedout
    }
    
    // authentication state.
    var state = AuthenticationState.loggedout {
        
        // Update the UI on a change.
        didSet {
            if state == .loggedin {
               showHome()
            }
        }
    }

    @IBOutlet weak var pinLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSettings()
        self.hideKeyboardWhenTappedAround()
        
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
        // initial app state
        state = .loggedout
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        login()
    }
    
    func login() {
        if isTouchEnabled {
            checkAuthentication()
        } else {
            if userPIN == pinLabel.text {
                showHome()
            } else {
                showError(title: "Login Error", message: "The PIN is wrong. Please try again")
            }
        }
    }

    func setupSettings() {
        isTouchEnabled = defaults.bool(forKey: "UseTouchID")
        userPIN = defaults.string(forKey: "UsePIN") ?? ""
    }
    
    func showHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(vc, animated: true)
    }

    // check login state
    func checkAuthentication() {
        
        if state == .loggedin {
            // Log out immediately.
            state = .loggedout
            
        } else {
            context = LAContext()
            context.localizedCancelTitle = "Enter PIN"
            
            // First check if we have the needed hardware support.
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    
                    if success {
                        
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                        }
                        
                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        
                        self.showError(title: "Login Error", message: "Failed to authenticate")
                        
                        // Fall back to a asking for username and password.
                        // ...
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")
                
                self.showError(title: "Login Error", message: "Failed to authenticate")
                // Fall back to a asking for username and password.
                // ...
            }
        }
    }
}


