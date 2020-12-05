//
//  MessageViewModel.swift
//  ChipChat
//
//  Created by Alexander Ha on 12/1/20.
//

import UIKit


struct MessageViewModel {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : .blue
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var leadingAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var trailingAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageURL: URL? {
        guard let user = message.user else { return nil }
        return URL(string: user.profileImageURL)
    }
    
    init(message: Message) {
        self.message = message
    }
    
    
}
