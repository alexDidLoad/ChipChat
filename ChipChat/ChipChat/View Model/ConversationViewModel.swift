//
//  ConversationViewModel.swift
//  ChipChat
//
//  Created by Alexander Ha on 12/5/20.
//

import UIKit

struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileImageURL: URL? {
        return URL(string: conversation.user.profileImageURL)
    }
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
    
}
