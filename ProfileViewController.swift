//
//  ProfileViewController.swift
//  Rate My Fit
//
//  Created by Kevin Hall on 12/12/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var userAvatar: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var username: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var defaultImage: UIImage = UIImage()
    
    var postedFits = [PFFile]()
    
    var objectIds = [String]()
    
    var objectIdToSend: String = ""
    
    let defaults = UserDefaults()
    
    @IBAction func logOut(_ sender: Any) {
        
        PFUser.logOut()
        
        defaults.set("LoginViewController", forKey: "LaunchView")
        
        self.performSegue(withIdentifier: "Log Out", sender: self)
        
    }
    
    @IBAction func viewSettings(_ sender: Any) {
        
        performSegue(withIdentifier: "ProfileToSettings", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfoAndFits()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postedFits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostedFitCollectionViewCell
        
        postedFits[indexPath.row].getDataInBackground { (data, error) in
            if let imageData = data {
                if let downloadedImage = UIImage(data: imageData) {
                    cell.postedFit.image = downloadedImage
                }
            }
        }
        
        return cell
        
    }
    
    func getUserInfoAndFits() -> Void {
        
        name.text = PFUser.current()?["name"] as! String?
        
        username.text = "@\((PFUser.current()?["username"] as! String?)!)"
        
        defaultImage = userAvatar.image!
        
        let query = PFUser.query()
        
        query?.getObjectInBackground(withId: (PFUser.current()?.objectId)!, block: { (object, error) in
            if let user = object {
                if let image = user["avatar"] {
                    
                    (image as! PFFile).getDataInBackground(block: { (data, error) in
                        if let imageData = data {
                            
                            if let downloadedAvatar = UIImage(data: imageData) {
                                
                                self.userAvatar.image = downloadedAvatar
                                
                            }
                        }
                    })
                } else {
                    self.userAvatar.image = self.defaultImage
                }
            }
        })
        
        let getPostedFitsQuery = PFQuery(className: "Fits")
        
        getPostedFitsQuery.whereKey("user", equalTo: (PFUser.current()?.username)!)
        
        getPostedFitsQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
                print("success")
                if let fits = objects {
                    print("double succss")
                    for fit in fits {
                        print("triple success")
                        self.postedFits.append(fit["image"] as! PFFile)
                        self.objectIds.append(fit.objectId!)
                        
                    }
                }
            } else {
                print("eror")
            }
            self.collectionView.reloadData()
            print(self.postedFits.count)
            print(self.objectIds.count)
            self.postedFits.reverse()
            self.objectIds.reverse()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        objectIdToSend = objectIds[indexPath.row]
        
        print(objectIdToSend)
        
        performSegue(withIdentifier: "ViewOwnFit", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewOwnFit" {
            
            let UUFVC = segue.destination as! UserUploadedFitViewController
            
            UUFVC.sentObjectId = self.objectIdToSend
            
            print (UUFVC.sentObjectId)
            
        } else if segue.identifier == "ProfileToSettings" {
            print("gucci")
        }
    }
}
