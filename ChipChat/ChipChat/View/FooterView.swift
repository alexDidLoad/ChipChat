//
//  FooterView.swift
//  ChipChat
//
//  Created by Alexander Ha on 12/5/20.
//

import UIKit

protocol FooterViewDelegate: class {
    func handleLogout()
}

class FooterView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: FooterViewDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemRed
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(leading: leadingAnchor,
                            trailing: trailingAnchor,
                            paddingLeading: 32,
                            paddingTrailing: 32)
        logoutButton.setHeight(height: 50)
        logoutButton.centerY(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleLogout() {
        
        delegate?.handleLogout()
    }
    
}
