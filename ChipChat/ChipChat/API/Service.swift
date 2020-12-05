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
    static func fetchUsers(completion: @escaping([User]) -> Void ) {
        
        var users = [User]()
        //reaches out to firestore database with the users collection
            COLLECTION_USERS.getDocuments { snapshot, error in
            //loops through each document and retrieves the data
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
                completion(users)
            })
            
        }
    }
    
    static func fetchUser(withUID uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
        
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        let data = ["fromID" : currentUID,
                    "toID" : user.uid,
                    "text" : message,
                    "timestamp" : Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_MESSAGES.document(currentUID).collection(user.uid).addDocument(data: data) { _ in
            COLLECTION_MESSAGES.document(user.uid).collection(currentUID).addDocument(data: data, completion: completion)
            
            //creates a new data structure in firebase for both receiving and sending users
            COLLECTION_MESSAGES.document(currentUID).collection("recent-messages").document(user.uid).setData(data)
            COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUID).setData(data)
        }
    }
    
    
    /// Fetching message from firestore database
    /// - Parameters:
    ///   - user: The current user requesting the message
    ///   - completion: Returns an array of Message objects that were requested
    static func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        //sets a query to read from the pathway below
        let query = COLLECTION_MESSAGES.document(currentUID).collection(user.uid).order(by: "timestamp")
        //snapshot listener is an observer that constantly updates the query
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(withUID: message.toID) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
}
