//
//  User.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/29/20.
//

import UIKit

struct User {
    
    let email: String
    let fullname: String
    let username: String
    let uid: String
    let profileImageURL: String
    
    //initializes user struct with dictionary data from firestore
    init(dictionary: [String : Any]) {
        
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
       
    }
}
