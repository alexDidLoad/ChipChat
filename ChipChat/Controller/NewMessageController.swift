//
//  NewMessageController.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/29/20.
//

import UIKit

private let reuseIdentifier = "UserCell"

class NewMessageController: UITableViewController {
    
    //MARK: - Properties
    
    private var users = [User]()
    
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
        Service.fetchUser { [weak self] users in
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

//MARK: - UITableViewDataSource

extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
