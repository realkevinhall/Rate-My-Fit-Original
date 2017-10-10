//
//  UploadViewController.swift
//  Rate My Fit
//
//  Created by Kevin Hall on 12/4/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import UIKit
import Parse

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    let imagePicker = UIImagePickerController()
    
    let alertController = UIAlertController(title: "Upload Outfit", message: "Select how you will upload your outfit", preferredStyle: .actionSheet)

    @IBOutlet var fitToUpload: UIImageView!
    
    @IBOutlet var postOutfitButton: UIButton!
    
    @IBAction func selectOutfit(_ sender: Any) {
        
        self.present(alertController, animated: true)
        
    }
    
    @IBAction func postOutfit(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let fit = PFObject(className: "Fits")
        
        let imageData = fitToUpload.image!.jpegData(.medium)
        
        let imageFile = PFFile(name: "fit.jpeg", data: imageData!)
        
        fit["image"] = imageFile
        
        fit["user"] = PFUser.current()?.username
        
        fit["likes"] = 0
        
        fit["dislikes"] = 0
        
        fit["liked"] = []
        
        fit["disliked"] = []
        
        let acl = PFACL()
        
        acl.getPublicWriteAccess = true
        
        acl.getPublicReadAccess = true
        
        fit.acl = acl
        
        fit.saveInBackground(block: {(success, error) in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                self.createAlert(title: "Could not upload your fit", message: "Please try again")
                
            } else {
                
                self.createAlert(title: "Success", message: "Your fit has been posted")
                
                self.fitToUpload.image = nil
                
            }
        
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postOutfitButton.isEnabled = false
        
        postOutfitButton.alpha = 0
        
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

    override func didReceiveMemoryWarning() {
    
        super.didReceiveMemoryWarning()

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            fitToUpload.image! = image
            
        }
        
        postOutfitButton.isEnabled = true
        
        postOutfitButton.alpha = 1
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
