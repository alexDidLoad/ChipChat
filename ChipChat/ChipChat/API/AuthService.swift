//
//  AuthService.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/28/20.
//
import UIKit
import Firebase

struct RegistrationCredentials {
    
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

//contains functions that reach out to database
struct AuthService {
    
    static let shared = AuthService()
    
    func logUserIn(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(credentials: RegistrationCredentials, completion: ((Error?) -> Void)?) {
        //upload profile image
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        reference.putData(imageData, metadata: nil) { (meta, error) in
            //handle error
            if let error = error {
                completion!(error)
                return
            }
            reference.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else { return }
                
                //create and authenticate user
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        completion!(error)
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    
                    //creating data dictionary
                    let data = ["profileImageURL" : profileImageURL,
                                "email" : credentials.email,
                                "password" : credentials.password,
                                "username" : credentials.username,
                                "uid" : uid,
                                "fullname" : credentials.fullname] as [String : Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                }
            }
        }
    }
    
}
