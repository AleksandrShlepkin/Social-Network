//
//  FriendsViewController.swift
//  Social Network
//
//  Created by Alex on 01.07.2021.
//
// Hello world

import UIKit

class FriendsViewController: UIViewController {
    
    private var apiservice = APIService()
    private var friends: [Item] = []
    
    @IBOutlet weak var FriendTableView: UITableView! {
        didSet {
            FriendTableView.delegate = self
            FriendTableView.dataSource = self
            FriendTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FriendTableView")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        group.enter()
        apiservice.getFriend{ [weak self] users in
            guard let self = self else { return }
            self.friends = users
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.FriendTableView.reloadData()
            
        }
        
    }
    
}




extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FriendTableView.dequeueReusableCell(withIdentifier: "FriendTableView", for: indexPath)
        let user = friends[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        return cell
    }
    
    
}
