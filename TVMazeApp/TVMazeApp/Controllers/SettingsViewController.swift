//
//  SettingsViewController.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var pinLabel: UITextField!
    @IBOutlet weak var touchIDSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadSettings()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        saveSettings()
    }
    
    func saveSettings() {
        defaults.set(touchIDSwitch.isOn, forKey: "UseTouchID")
        defaults.set(pinLabel.text, forKey: "UsePIN")
        defaults.synchronize()
        
        self.showMessage(title: "Settings", message: "Successfully Saved!")
    }
    
    func loadSettings() {
        touchIDSwitch.isOn = defaults.bool(forKey: "UseTouchID")
        pinLabel.text = defaults.string(forKey: "UsePIN")
    }
    
}
