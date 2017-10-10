//
//  LoginViewController.swift
//  Rate My Fit
//
//  Created by Kevin Hall on 11/24/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var logInButton: UIButton!
    
    @IBOutlet var signUpSegueButton: UIButton!
    
    @IBOutlet var usernameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    var activityIndicator = UIActivityIndicatorView()
    
    var segueUsername:String = ""
    
    var seguePassword:String = ""
    
    var defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 5
        signUpSegueButton.layer.cornerRadius = 5
        logInButton.isEnabled = false
        logInButton.alpha = 0.6
        
        if segueUsername != "" {
            
            usernameField.text = segueUsername
            
            if seguePassword != "" {
                
                passwordField.text = seguePassword
                
            }
            
        }
        
        usernameField.delegate = self
        passwordField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
    
        super.didReceiveMemoryWarning()
    
    }
    
    @IBAction func logIn(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!, block: { (user, error) in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                var displayErrorMessage = "Please Try Again Later"
                
                if let errorMessage = (error! as NSError).userInfo["error"] as? String {
                    
                    displayErrorMessage = errorMessage
                }
                
                self.createAlert(title: "Login Error", message: displayErrorMessage)
                
            } else {
                
                print("Logged In")
                
                self.performSegue(withIdentifier: "logInEntry", sender: self)
                
                self.defaults.set("FitsViewController", forKey: "LaunchView")
                
            }
        })
    }
    
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            
            self.performSegue(withIdentifier: "logInEntry", sender: self)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let changingText = textField.text!
        
        let changedText = removeCharacters(originalString: changingText)
        
        textField.text = changedText
        
        if usernameField.text != "" && passwordField.text!.characters.count >= 4 {
            
            logInButton.isEnabled = true
            
            logInButton.alpha = 1
            
        } else {
            
            logInButton.isEnabled = false
            
            logInButton.alpha = 0.6
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            case self.usernameField:
                self.passwordField.becomeFirstResponder()
                break
            default:
                self.view.endEditing(true)
        }
        
        return true
        
    }
    
    func removeCharacters(originalString: String) -> String {
        
        var changedString = originalString
        
        changedString = changedString.removingCharacters(inCharacterSet: CharacterSet.illegalCharacters)
        
        changedString = changedString.removingCharacters(inCharacterSet: CharacterSet.whitespacesAndNewlines)
        
        changedString = changedString.removingCharacters(inCharacterSet: CharacterSet.symbols)
            
        changedString = changedString.removingCharacters(inCharacterSet: CharacterSet.punctuationCharacters)
        
        return changedString
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "LogInToSignUp" {
            
            let signupViewController = segue.destination as! SignupViewController
            
            if usernameField.text != "" {
                
                signupViewController.segueUsername = usernameField.text!
                
                if passwordField.text != "" {
                    
                    signupViewController.seguePassword = passwordField.text!
                
                }
                
            }
        }
    }
}
