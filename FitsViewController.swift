//
//  FitsViewController.swift
//  Rate My Fit
//
//  Created by Kevin Hall on 12/4/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import UIKit
import Parse

class FitsViewController: UIViewController, UINavigationControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    let defaults = UserDefaults()
    
    let username: String = (PFUser.current()?.username!)!
    
    let userObjectId: String = (PFUser.current()?.objectId!)!
    
    var currentImageObjectId: String = ""
    
    var toolbarColor = UIColor()
    
    var greenColor = UIColor()
    
    let alertController = UIAlertController(title: "Report Outfit", message: "Report inappropriate content", preferredStyle: .actionSheet)
    
    @IBOutlet var outfitImage: UIImageView!
    
    @IBOutlet var likesLabel: UILabel!
    
    @IBOutlet var dislikesLabel: UILabel!
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var likeButton: UIButton!
    
    @IBOutlet var dislikeButton: UIButton!
    
    var imageObjectId = ""
    
    @IBAction func refreshBarButton(_ sender: Any) {
        
        updateImage()
        
    }
    
    @IBOutlet var actionSheetLaunchButton: UIBarButtonItem!
    
    @IBAction func flagOutfit(_ sender: Any) {
        
        self.present(alertController, animated: true)
    
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        likeButton.layer.cornerRadius = 5
        
        dislikeButton.layer.cornerRadius = 5
        
        toolbarColor = self.hexStringToUIColor(hex: "#F9F9F9")
        
        greenColor = self.hexStringToUIColor(hex: "#056F00")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(cancelAction)
        
        let flagAction = UIAlertAction(title: "Flag Outfit", style: .default) { (action) in
            
            self.flagImage(imageObjectId: self.currentImageObjectId)
            
        }
        
        alertController.addAction(flagAction)
        
        // let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        // outfitImage.isUserInteractionEnabled = true
        
        // outfitImage.addGestureRecognizer(gesture)
        
        self.likesLabel.text = ""
        
        self.dislikesLabel.text = ""
        
        self.likeButton.alpha = 0
        
        self.dislikeButton.alpha = 0
        
        updateImage()
        
    }
    
    /*func wasDragged(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        
        let translation = gestureRecognizer.translation(in: view)
        
        outfitImage.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = outfitImage.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 400)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        outfitImage.transform = stretchAndRotation
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            let updateQuery = PFQuery(className: "Fits")
            
            updateQuery.getObjectInBackground(withId: currentImageObjectId, block: { (object, error) in
                
                if let databaseImage = object {
                    
                    if self.outfitImage.center.x < 100 {
                        
                        print("liked")
                        
                        PFUser.current()?.add(self.currentImageObjectId, forKey: "votedOn")
                        
                        PFUser.current()?.saveInBackground(block: { (success, error) in
                            if error == nil {
                                
                                databaseImage["likes"] = databaseImage["likes"] as! Int + 1
                                
                                databaseImage.saveInBackground(block: { (success, error) in
                                    
                                    if error != nil {
                                        
                                    } else {
                                        
                                        rotation = CGAffineTransform(rotationAngle: 0)
                                        
                                        stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
                                        
                                        self.outfitImage.transform = stretchAndRotation
                                        
                                        self.outfitImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
                                        
                                        self.updateImage()
                                        
                                    }
                                })
                                
                            }
                        })
                        
                        
                    } else {
                        
                        print("disliked")
                        
                        PFUser.current()?.add(self.currentImageObjectId, forKey: "votedOn")
                        
                        PFUser.current()?.saveInBackground(block: { (success, error) in
                            if error == nil {
                                
                                databaseImage["dislikes"] = databaseImage["dislikes"] as! Int + 1
                                
                                databaseImage.saveInBackground(block: { (success, error) in
                                    
                                    if error != nil {
                                        
                                    } else {
                                        
                                        rotation = CGAffineTransform(rotationAngle: 0)
                                        
                                        stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
                                        
                                        self.outfitImage.transform = stretchAndRotation
                                        
                                        self.outfitImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
                                        
                                        self.updateImage()
                                    }
                                })
                            }
                        })
                        
                    }
                }
                
                rotation = CGAffineTransform(rotationAngle: 0)
                
                stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
                
                self.outfitImage.transform = stretchAndRotation
                
                self.outfitImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
                
                self.updateImage()
            })
            
        }
    }*/
    
    func updateImage() -> Void {
        
        var ignoredFits = [""]
        
        if let votedOn = PFUser.current()?["votedOn"] {
            
            ignoredFits = votedOn as! [String]
            
        }
        
        print(ignoredFits)
        
        let query = PFQuery(className: "Fits")
        
        query.whereKey("user", notEqualTo: self.username)
        
        query.whereKey("objectId", notContainedIn: ignoredFits)
        
        query.whereKey("flagged", notEqualTo: true)
        
        query.getFirstObjectInBackground (block: { (object, error) in
            
            if error == nil {
                
                self.errorLabel.alpha = 0
                
                self.outfitImage.alpha = 1
                
                self.likesLabel.alpha = 1
                
                self.dislikesLabel.alpha = 1
                
                self.likeButton.alpha = 1
                
                self.dislikeButton.alpha = 1
                
                self.actionSheetLaunchButton.tintColor = self.greenColor
                
                self.actionSheetLaunchButton.isEnabled = true
                
                if let row = object {
                    
                    let image = row["image"] as! PFFile
                    
                    let likes = String(describing: row["likes"]!)
                    
                    let dislikes = String(describing: row["dislikes"]!)
                    
                    image.getDataInBackground(block: { (data, error) in
                        
                        if let imageData = data {
                            
                            let postedFit = UIImage(data: imageData)
                            
                            self.outfitImage.image! = postedFit!
                            
                            self.likesLabel.text = likes
                            
                            self.dislikesLabel.text = dislikes
                            
                            self.currentImageObjectId = row.objectId!
                            
                        }
                        
                    })
                    
                }
                
            } else {
                
                self.outfitImage.alpha = 0
                
                self.likesLabel.alpha = 0
                
                self.likeButton.alpha = 0
                
                self.dislikeButton.alpha = 0
                
                self.dislikesLabel.alpha = 0
                
                self.errorLabel.alpha = 1
                
                self.actionSheetLaunchButton.tintColor = self.toolbarColor
                
                self.actionSheetLaunchButton.isEnabled = false
                
            }
            
        })
        
    }
    
    func flagImage(imageObjectId: String) {
        
        let query = PFQuery(className: "Fits")
        
        query.getObjectInBackground(withId: imageObjectId) { (object, error) in
            
            if error == nil {
                
                object?["flagged"] = true
                
                object?.saveInBackground()
                
                self.updateImage()
                
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func likeOutfit(_ sender: Any) {
        
        let updateQuery = PFQuery(className: "Fits")
        
        updateQuery.getObjectInBackground(withId: currentImageObjectId, block: { (object, error) in
            
            if let databaseImage = object {
                    
                    print("liked")
                    
                    PFUser.current()?.add(self.currentImageObjectId, forKey: "votedOn")
                    
                    PFUser.current()?.saveInBackground(block: { (success, error) in
                        
                        if error == nil {
                            
                            databaseImage["likes"] = databaseImage["likes"] as! Int + 1
                            
                            databaseImage.saveInBackground(block: { (success, error) in
                                
                                if error != nil {
                                    
                                } else {
            
                                    
                                    self.updateImage()
                                    
                                }
                            })
                        }
                    })
                    
                    
                }
        })
        
    }
    
    
    @IBAction func dislikeOutfit(_ sender: Any) {
        
        let updateQuery = PFQuery(className: "Fits")
        
        updateQuery.getObjectInBackground(withId: currentImageObjectId) { (object, error) in
            
            if let databaseImage = object {
                
                print("disliked")
                
                PFUser.current()?.add(self.currentImageObjectId, forKey: "votedOn")
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    
                    if error == nil {
                        
                        databaseImage["dislikes"] = databaseImage["dislikes"] as! Int + 1
                        
                        databaseImage.saveInBackground(block: { (success, error) in
                            
                            if error != nil {
                                
                            } else {
                                
                                self.updateImage()
                                
                            }
                            
                        })
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        
        PFUser.logOut()
        
        defaults.set("LoginViewController", forKey: "LaunchView")
        
        self.performSegue(withIdentifier: "logOut", sender: self)
        
    }
    
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

