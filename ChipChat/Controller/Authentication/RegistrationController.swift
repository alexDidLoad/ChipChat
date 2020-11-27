//
//  RegistrationController.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/26/20.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "addPhoto"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var emailContainerView: InputContainerView = {
        return InputContainerView(image: "envelope", textField: emailTextField)
    }()
    
    private lazy var fullnameContainerView: InputContainerView = {
        return InputContainerView(image: "person", textField: fullnameTextField)
    }()
    
    private lazy var usernameContainerView: InputContainerView = {
        return InputContainerView(image: "person", textField: usernameTextField)
    }()
    
    private lazy var passwordContainerView: UIView = {
        return InputContainerView(image: "lock", textField: passwordTextField)
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    private let usernameTextField = CustomTextField(placeholder: "Username")
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let signUpButton: CustomAuthButton = {
        let button = CustomAuthButton(title: "Sign Up")
        button.addTarget(self, action: #selector(handleSignUpPressed), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ",
                                                        attributes: [.font : UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor : UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Log In",
                                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    
    //MARK: - Selectors
    
    @objc func handleAddPhoto() {
        print("add photo button pressed")
    }
    
    @objc func handleSignUpPressed() {
        print("sign up pressed")
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        configureGradientLayer()
        
        view.addSubview(addPhotoButton)
        addPhotoButton.centerX(inView: view)
        addPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              paddingTop: 32,
                              height: 200,
                              width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullnameContainerView,
                                                   usernameContainerView,
                                                   passwordContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: addPhotoButton.bottomAnchor,
                     leading: view.leadingAnchor,
                     trailing: view.trailingAnchor,
                     paddingTop: 32,
                     paddingLeading: 32,
                     paddingTrailing: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
}
