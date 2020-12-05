//
//  ProfileViewModel.swift
//  ChipChat
//
//  Created by Alexander Ha on 12/5/20.
//

import UIKit

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo
    case settings

    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .settings: return "Settings"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .settings: return "gear"
        }
    }
    
}
