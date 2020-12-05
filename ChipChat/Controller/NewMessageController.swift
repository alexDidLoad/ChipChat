//
//  NewMessageController.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/29/20.
//

import UIKit

protocol NewMessageControllerDelegate: class {
    
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}

private let reuseIdentifier = "UserCell"

class NewMessageController: UITableViewController {
    
    //MARK: - Properties
    
    private var users = [User]()
    
    weak var delegate: NewMessageControllerDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsers()
    }
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - API
    
    func fetchUsers() {
        Service.fetchUsers { [weak self] users in
            self?.users = users
            self?.tableView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        configureNavBar(withTitle: "New Message", prefersLargeTitle: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        
    }
}

//MARK: - NewMessageController TableView Extensions

extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //This will call the function declared in the ConversationsControllerVC because it is the delegate of NewMessageController
        delegate?.controller(self, wantsToStartChatWith: users[indexPath.row])
    }
    
}
