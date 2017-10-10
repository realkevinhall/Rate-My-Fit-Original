//
//  UserInfoViewController.swift
//  Rate My Fit
//
//  Created by Kevin Hall on 12/12/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import UIKit
import Parse

class UserInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet var avatarToUpload: UIImageView!
    
    var activityIndicator = UIActivityIndicatorView()
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var name: UITextField!
    
    let alertController = UIAlertController(title: "Upload Avatar", message: "Select how you will upload your avatar", preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(cancelAction)
        
        let cameraRollAction = UIAlertAction(title: "From Camera Roll", style: .default) { (action) in
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
        
        alertController.addAction(cameraRollAction)
        
        let takePictureAction = UIAlertAction(title: "Take Picture", style: .default) { (action) in
        
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
        
        alertController.addAction(takePictureAction)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            avatarToUpload.image! = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    

    @IBAction func uploadAvatar(_ sender: Any) {
        self.present(alertController, animated: true)
    }

    @IBAction func uploadUserInfo(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        PFUser.current()?["name"] = name.text!
        
        let imageData = avatarToUpload.image!.jpegData(.medium)
        
        let imageFile = PFFile(name: "avatar.jpeg", data: imageData!)
        
        PFUser.current()?["avatar"] = imageFile
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                self.createAlert(title: "Could not save your information", message: "Please try again")
                
            } else {
                
                self.performSegue(withIdentifier: "InfoToApp", sender: self)
                
            }
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    
    }
    
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }


}
