//
//  LoginViewModel.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/27/20.
//

import UIKit

struct AuthViewModel {
    
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
}
