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
    private var filteredUsers = [User]()
    weak var delegate: NewMessageControllerDelegate?
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive &&
            !(searchController.searchBar.text!.isEmpty)
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSearchController()
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
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.showsCancelButton = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        definesPresentationContext = false
        navigationItem.searchController = searchController
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .black
            textField.backgroundColor = .white
        }
    }
    
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
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        //This will call the function declared in the ConversationsControllerVC because it is the delegate of NewMessageController
        delegate?.controller(self, wantsToStartChatWith: user)
    }
    
}

//MARK: - Search Results updater

extension NewMessageController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({ user -> Bool in
            return user.username.contains(searchText) || user.fullname.contains(searchText)
            
        })
        self.tableView.reloadData()
    }
}
