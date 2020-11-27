//
//  RegistrationViewModel.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/27/20.
//

import UIKit

struct RegistrationViewModel: AuthenticationProtocol {
    
    var email: String?
    var password: String?
    var username: String?
    var fullname: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && username?.isEmpty == false
            && fullname?.isEmpty == false
    }
}
