//
//  LoginController.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/26/20.
//

import UIKit
import JGProgressHUD
import Firebase

protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}

protocol AuthenticationDelegate: class {
    func authenticationComplete()
}

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var loginViewModel = LoginViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
    //creating view component programmatically
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    //Created lazily in order to add emailTextField which may not exist at the time of creation
    private lazy var emailContainerView: InputContainerView = {
        return InputContainerView(image: "envelope", textField: emailTextField)
    }()
    
    private lazy var passwordContainerView: UIView = {
        return InputContainerView(image: "lock", textField: passwordTextField)
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: CustomAuthButton = {
        let button = CustomAuthButton(title: "Log In")
        button.addTarget(self, action: #selector(handleLoginPressed), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ",
                                                        attributes: [.font : UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor : UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign Up",
                                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - Selectors
    
    @objc func handleLoginPressed() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        showProgressHud(true, withText: "Logging in")
        
        AuthService.shared.logUserIn(email: email, password: password) { [weak self] (result, error) in
            if let error = error {
                print("DEBUG: Failed to login: \(error.localizedDescription)")
                self?.showProgressHud(false)
                return
            }
            self?.showProgressHud(false)
            self?.delegate?.authenticationComplete()
        }
        loginButton.bounce()
    }
    
    @objc func handleShowSignUp() {
        let vc = RegistrationController()
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            loginViewModel.email = sender.text
        } else {
            loginViewModel.password = sender.text
        }
        checkFormStatus()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        hideKeyboardOnTap()
        
        navigationController?.navigationBar.isHidden = true
        //changes status bar to white
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32, height: 120, width: 120)
        
        //adding component views into stack view
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor,
                     leading: view.leadingAnchor,
                     trailing: view.trailingAnchor,
                     paddingTop: 32,
                     paddingLeading: 32,
                     paddingTrailing: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}

//MARK: - Authentication Protocol

extension LoginController: AuthenticationControllerProtocol {
    
    func checkFormStatus() {
        if loginViewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .white
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .init(white: 1, alpha: 0.25)
        }
    }
    
}
