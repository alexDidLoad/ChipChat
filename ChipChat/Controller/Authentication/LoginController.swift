//
//  LoginController.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/26/20.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    //creating view component programmatically
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        
        return iv
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        //changes status bar to white
        navigationController?.navigationBar.barStyle = .black

        configureGradientLayer()
    }
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor, #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor]
        //sets the two points at the top to the bottom
        gradient.locations = [0, 1]
        
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    
    
}
