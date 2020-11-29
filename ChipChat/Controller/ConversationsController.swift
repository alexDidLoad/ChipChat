//
//  ConversationsController.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/26/20.
//

import UIKit
import Firebase


private let reuseIdentifier = "conversationCell"

class ConversationsController: UIViewController {
    
    //MARK: - Properties
    
    private let tableView = UITableView()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.tintColor = .white
        button.imageView?.setDimensions(height: 36, width: 36)
        button.setDimensions(height: 56, width: 56)
        button.layer.cornerRadius = 56 / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        authenticateUser()
        
    }
    
    //MARK: - Selectors
    
    @objc func showProfile() {
        logout()
    }
    
    @objc func showNewMessage() {
        
        let msgController = NewMessageController()
        let nav = UINavigationController(rootViewController: msgController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //MARK: - API
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        } else {
            print("DEBUG: User is logged in, UserID: \(Auth.auth().currentUser!.uid)")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG: Error signing out...")
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        configureNavBar()
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(newMessageButton)
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 16, paddingTrailing: 24)
        
    }
    
    func configureNavBar() {
        
        //Creating a constant with our customized settings
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        //Sets all of the navigation bar's attributes to our constant 'appearance'
        navigationItem.title = "Messages"
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        
        //overrides status bar to be white (battery | wifi symbol | time)
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func configureTableView() {
        
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        //removes separator lines if the cells contain nothing
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let loginVC = LoginController()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
}

//MARK: - ConversationsController TableView Extensions

extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "test cell"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ConversationsController: UITableViewDelegate {
    
}
