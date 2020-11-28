//
//  RegistrationController.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/26/20.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private var registerViewModel = RegistrationViewModel()
    
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "addPhoto"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()
    
    private var profileImage: UIImage?
    
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
        configureNotificationObserver()
        
    }
    
    //MARK: - Selectors
    
    @objc func handleAddPhoto() {
        //allows you to select an image/video
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @objc func handleSignUpPressed() {
        //grab the users profile image, and all the info in the text fields and send it to database
        guard let profileImage = profileImage else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        
        //upload profile image
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        reference.putData(imageData, metadata: nil) { (meta, error) in
            //handle error
            if let error = error {
                print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
                return
            }
            reference.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else { return }
                
                //create and authenticate user
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Failed to create user with error \(error.localizedDescription)")
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    
                    //creating data dictionary
                    let data = ["profileImageURL" : profileImageURL,
                                "email" : email,
                                "password" : password,
                                "username" : username,
                                "uid" : uid,
                                "fullname" : fullname] as [String : Any]
                    
                    //upload information to database
                    Firestore.firestore().collection("users").document(uid).setData(data) { error in
                        if let error = error {
                            print("DEBUG: Failed to upload user data with error \(error.localizedDescription)")
                            return
                        }
                        print("DEBUG: Did create user...")
                    }
                }
            }
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        
        if sender == emailTextField {
            registerViewModel.email = sender.text
        } else if sender == fullnameTextField {
            registerViewModel.fullname = sender.text
        } else if sender == usernameTextField {
            registerViewModel.username = sender.text
        } else {
            registerViewModel.password = sender.text
        }
        checkFormStatus()
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
        
        let stack = UIStackView(arrangedSubviews: [fullnameContainerView,
                                                   emailContainerView,
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
    
    
    func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //grabs selected image from picker
        let image = info[.originalImage] as? UIImage
        profileImage = image
        //sets image to the button
        addPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.layer.borderWidth = 3.0
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
        addPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: - Authentication Protocol

extension RegistrationController: AuthenticationControllerProtocol {
    
    func checkFormStatus() {
        if registerViewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .white
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .init(white: 1, alpha: 0.25)
        }
    }
}
