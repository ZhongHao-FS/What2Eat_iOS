//
//  Utility.swift
//  What2Eat_iOS
//
//  Created by Hao Zhong on 3/24/22.
//

import Foundation
import FirebaseStorage

class Utility {
    static func validateStrInput(_ input: String?) -> String {
        if let text = input {
            if text.isEmpty == false {
                return text
            }
        }
        return ""
    }
    
    static func createStorageReference(_ uid: String) -> StorageReference {
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("images/" + uid)
        let fileName = "profile.jpg"
        
        return imageRef.child(fileName)
    }
    
}
