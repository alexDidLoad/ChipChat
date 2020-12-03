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
    
   static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        let data = ["fromID" : currentUID,
                    "toID" : user.uid,
                    "text" : message,
                    "timestamp" : Date()] as [String : Any]
        
        COLLECTION_MESSAGES.document(currentUID).collection(user.uid).addDocument(data: data) { _ in
            COLLECTION_MESSAGES.document(user.uid).collection(currentUID).addDocument(data: data, completion: completion)
        }
    }
    
}
