//
//  GroupsViewController.swift
//  Social Network
//
//  Created by Alex on 01.07.2021.
//

import UIKit

class GroupsViewController: UIViewController {
    
    @IBOutlet weak var GroupsTableView: UITableView!{
        didSet {
            GroupsTableView.delegate = self
            GroupsTableView.dataSource = self
            GroupsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "GroupsTableView")
        }
    }
    private  var apiservice = APIService()
    private var groups: [Group] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        group.enter()
        apiservice.getGroup { [weak self] usersGroups in
            guard let self = self else { return }
            self.groups = usersGroups
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.GroupsTableView.reloadData()
            
        }
        
    }
    
    
}
extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GroupsTableView.dequeueReusableCell(withIdentifier: "GroupsTableView", for: indexPath)
        let userGroups = groups[indexPath.row]
        cell.textLabel?.text = "\(userGroups.name) \(userGroups.screenName)"
        return cell
    }
    
    
}
