//
//  CustomAuthButton.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/27/20.
//

import UIKit


class CustomAuthButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
        setHeight(height: 50)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
