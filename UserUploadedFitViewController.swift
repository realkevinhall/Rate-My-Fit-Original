//
//  UserUploadedFitViewController.swift
//  Rate My Fit
//
//  Created by Kevin Hall on 12/18/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import UIKit
import Parse

class UserUploadedFitViewController: UIViewController {
    
    @IBOutlet var postedFit: UIImageView!
    
    @IBOutlet var likesLabel: UILabel!
    
    @IBOutlet var dislikesLabel: UILabel!
    
    var sentObjectId: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadPostedFit()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadPostedFit() -> Void {
        
        let query = PFQuery(className: "Fits")
        
        query.whereKey("objectId", equalTo: self.sentObjectId)
        
        query.getFirstObjectInBackground { (object, error) in
            
            if error == nil {
                
                if let fit = object {
                    
                    self.likesLabel.text = String(describing: fit["likes"]!)
                    
                    self.dislikesLabel.text = String(describing: fit["dislikes"]!)
                    
                    if let image = fit["image"] {
                        
                        (image as! PFFile).getDataInBackground(block: { (data, error) in
                            
                            if let imageData = data {
                                
                                if let downloadedImage = UIImage(data: imageData) {
                                    
                                    self.postedFit.image = downloadedImage
                                    
                                }
                                
                            }
                        })
                    }
                }
            }
            
        }
    }
}
