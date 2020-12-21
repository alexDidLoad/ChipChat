//
//  Message.swift
//  ChipChat
//
//  Created by Alexander Ha on 12/1/20.
//

import Firebase

struct Message {
    
    let text: String
    let toID: String
    let fromID: String
    var timestamp: Timestamp!
    var user: User?
    let isFromCurrentUser: Bool
    
    var chatPartnerID: String {
        return isFromCurrentUser ? toID : fromID
    }
    
    init(dictionary: [String : Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toID = dictionary["toID"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromID == Auth.auth().currentUser?.uid
    }
}

struct Conversation {
    let user: User
    let message: Message
}
