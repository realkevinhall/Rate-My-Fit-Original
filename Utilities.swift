//
//  Utilities.swift
//  Rate My Fit
//
//  Created by Kevin Hall on 12/4/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func removingCharacters(inCharacterSet forbiddenCharacters:CharacterSet) -> String {
        var filteredString = self
        while true {
            if let forbiddenCharRange = filteredString.rangeOfCharacter(from: forbiddenCharacters)  {
                filteredString.removeSubrange(forbiddenCharRange)
            }
            else {
                break
            }
        }
        
        return filteredString
    }
    
}

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpegData(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
}
