//
//  ViewController.swift
//  Rate My Fit
//
//  Created by Kevin Hall on 11/24/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var signupButton: UIButton!

    @IBOutlet var loginSegueButton: UIButton!
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var usernameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var confirmPasswordField: UITextField!
    
    var activityIndicator = UIActivityIndicatorView()
    
    var segueUsername:String = ""
    
    var seguePassword:String = ""
    
    var segueTOSEmail:String = ""
    
    var segueTOSUsername:String = ""
    
    var segueTOSPassword:String = ""
    
    var segueTOSConfirmPassword:String = ""
    
    var defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = 5
        loginSegueButton.layer.cornerRadius = 5
        signupButton.isEnabled = false
        signupButton.alpha = 0.6
        
        if segueUsername != "" {
            
            usernameField.text = segueUsername
            
            if seguePassword != "" {
                
                passwordField.text = seguePassword
                
            }
            
        }
        
        if segueTOSEmail != "" {
            
            emailField.text = segueTOSEmail
        
        }
        
        if segueTOSUsername != "" {
            
            usernameField.text = segueTOSUsername
            
        }
        
        if segueTOSPassword != "" {
            
            passwordField.text = segueTOSPassword
            
            if segueTOSConfirmPassword != "" {
                
                confirmPasswordField.text = segueTOSConfirmPassword
                
            }
            
        }
        
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "SignupEntry", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func signUp(_ sender: Any) {
        
        if passwordField.text == confirmPasswordField.text {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            let user = PFUser()
            
            user.username = usernameField.text
        
            user.email = emailField.text

            user.password = passwordField.text
            
            user["blocked"] = false
            
            let acl = PFACL()
            
            acl.getPublicWriteAccess = true
            
            acl.getPublicReadAccess = true
            
            user.acl = acl
            
            user.signUpInBackground(block: { (success, error) in
                
                self.activityIndicator.stopAnimating()
                
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error != nil {
                    
                    var displayErrorMessage = "Please Try Again Later"
                    
                    if let errorMessage = (error! as NSError).userInfo["error"] as? String {
                        
                        displayErrorMessage = errorMessage
                    }
                    
                    self.createAlert(title: "Signup Error", message: displayErrorMessage)
                    
                } else {
                    
                    print("User Signed Up")
                    
                    user.acl = PFACL(user: user)
                    
                    user.saveInBackground()
                    
                    self.performSegue(withIdentifier: "SignupToUserInfo", sender: self)
                    
                    self.defaults.set("FitsViewController", forKey: "LaunchView")
                
                }

            })
    
        } else {
            
            createAlert(title: "Password Error", message: "Your passwords do not match, please try again")
            
        }
    }
    
    @IBAction func viewTOS(_ sender: Any) {
        print("yo")
        performSegue(withIdentifier: "SignupToTOS", sender: self)
        
    }
    
    
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if emailField.text!.contains("@") && usernameField.text != "" && passwordField.text!.characters.count >= 4 && confirmPasswordField.text!.characters.count >= 4 {
            
            signupButton.isEnabled = true
            
            signupButton.alpha = 1
            
        } else {
            
            signupButton.isEnabled = false
            
            signupButton.alpha = 0.6
            
        }
        
    }
    
    /*func removeCharacters(originalString: String, isEmail: Bool) -> String {
        var changedString = originalString
        
        changedString = changedString.removingCharacters(inCharacterSet: CharacterSet.illegalCharacters)
        
        changedString = changedString.removingCharacters(inCharacterSet: CharacterSet.whitespacesAndNewlines)
        
        if isEmail == false {
            
            changedString = changedString.removingCharacters(inCharacterSet: CharacterSet.symbols)
            
            changedString = changedString.removingCharacters(inCharacterSet: CharacterSet.punctuationCharacters)
        
        }
        
        return changedString
    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            case self.emailField:
                self.usernameField.becomeFirstResponder()
                break
            case self.usernameField:
                self.passwordField.becomeFirstResponder()
                break
            case self.passwordField:
                self.confirmPasswordField.becomeFirstResponder()
                break
            default:
                self.view.endEditing(true)
        }
        
        return true
    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignupToLogin" {
            
            let loginViewController = segue.destination as! LoginViewController
            
            if usernameField.text != "" {
                
                loginViewController.segueUsername = usernameField.text!
                
                if passwordField.text != "" {
                    
                    loginViewController.seguePassword = passwordField.text!
                    
                }
            }
            
        } else if segue.identifier == "SignupToTOS" {
            
            print("1")
            
            let TOSViewController = segue.destination as! TOSViewController
            
            print("6")
            
            if emailField.text! != "" {
                
                print("2")
                
                TOSViewController.emailHolder = emailField.text!
                
            }
            
            if usernameField.text! != "" {
                print("3")
                TOSViewController.usernameHolder = usernameField.text!
                
            }
            
            if passwordField.text! != "" {
                print("4")
                TOSViewController.passwordHolder = passwordField.text!
                
                if confirmPasswordField.text! != "" {
                    print("5")
                    TOSViewController.confirmPasswordHolder = confirmPasswordField.text!
                    
                }
            
            }
         
        }
        
    }

}
