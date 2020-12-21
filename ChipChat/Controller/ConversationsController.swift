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
    private var conversations = [Conversation]()
    private var conversationsDictionary = [String : Conversation]()
    
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
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar(withTitle: "Messages", prefersLargeTitle: true)
    }
    
    //MARK: - Selectors
    
    @objc func showProfile() {
       
        let profileController = ProfileController(style: .insetGrouped)
        profileController.delegate = self
        let nav = UINavigationController(rootViewController: profileController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
    }
    
    @objc func showNewMessage() {
        let msgController = NewMessageController()
        //This will make the ConversationController be the NewMessageControllers delegate
        msgController.delegate = self
        
        let nav = UINavigationController(rootViewController: msgController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //MARK: - API
    
    func fetchConversations() {
        Service.fetchConversations { conversations in
            
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerID] = conversation
            }
            self.conversations = Array(self.conversationsDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
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
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(newMessageButton)
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 16, paddingTrailing: 24)
        
    }
    
    func configureTableView() {
        
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        //removes separator lines if the cells contain nothing
        tableView.tableFooterView = UIView()
        tableView.register(ConversationsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let loginVC = LoginController()
            loginVC.delegate = self
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func showChatController(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

//MARK: - ConversationsController TableView Extensions

extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationsCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
}

extension ConversationsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
    }
    
}

//MARK: - NewMessageController Delegate

//conforms to the NewMessageControllerDelegate protocol and is required to implement the controller function
extension ConversationsController: NewMessageControllerDelegate {
    
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        dismiss(animated: true, completion: nil)
        showChatController(forUser: user)
    }
    
}

//MARK: - ProfileControllerDelegate

extension ConversationsController: ProfileControllerDelegate {
    func handleLogout() {
        logout()
    }
}

//MARK: - AuthenticationDelegate

extension ConversationsController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        configureUI()
        fetchConversations()
    }
    
    
}
