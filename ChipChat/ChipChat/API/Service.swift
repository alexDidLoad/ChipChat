//
//  Service.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/29/20.
//

import UIKit
import Firebase

struct Service {
    
    //completion block will enable us to use the user info in controller
    static func fetchUser(completion: @escaping([User]) -> Void ) {
        
        var users = [User]()
        
        //reaches out to firestore database with the users collection
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            
            //loops through each document and retrieves the data
            snapshot?.documents.forEach({ document in
               
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
                completion(users)
            })
            
        }
    }
    
}
