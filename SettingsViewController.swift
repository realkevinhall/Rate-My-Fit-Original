//
//  SettingsViewController.swift
//  Rate My Fit
//
//  Created by Kevin Hall on 2/7/17.
//  Copyright © 2017 Kevin Hall. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var resetPasswordButton: UIButton!
    @IBAction func resetPassword(_ sender: Any) {
        
        PFUser.requestPasswordResetForEmail(inBackground: (PFUser.current()?["email"] as! String))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        resetPasswordButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    
    }

}
