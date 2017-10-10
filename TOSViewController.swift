//
//  TOSViewController.swift
//  Rate My Fit
//
//  Created by Kevin Hall on 2/12/17.
//  Copyright © 2017 Kevin Hall. All rights reserved.
//

import UIKit

class TOSViewController: UIViewController, UIScrollViewDelegate {
    
    var emailHolder:String = ""
    
    var usernameHolder:String = ""
    
    var passwordHolder:String = ""
    
    var confirmPasswordHolder:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TOSToSignup" {
            
            let signupViewController = segue.destination as! SignupViewController
            
            if emailHolder != "" {
                
                signupViewController.segueTOSEmail = emailHolder
                
            }
            
            if usernameHolder != "" {
                
                signupViewController.segueTOSUsername = usernameHolder
                
            }
            
            if passwordHolder != "" {
                
                signupViewController.segueTOSPassword = passwordHolder
                
                if confirmPasswordHolder != "" {
                    
                    signupViewController.segueTOSConfirmPassword = confirmPasswordHolder
                    
                }
                
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
