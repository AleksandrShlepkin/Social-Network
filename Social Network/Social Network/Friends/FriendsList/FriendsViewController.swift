//
//  FriendsViewController.swift
//  Social Network
//
//  Created by Alex on 01.07.2021.
//
// Hello world

import UIKit

class FriendsViewController: UIViewController, UISearchBarDelegate {
    
    private var apiservice = ProxyFriendsAPI(friendsAPI: FriendsAPI())
    var friends: [ItemFriends] = []
    var photos: [ItemPhoto] = []
    private var apisevicePhoto = PhotoAPI()
    
    
    //MARK: Default Search Bar
    private var filterFriendsArray = [ItemFriends]()
    private let searchBar = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchBar.isActive && !searchBarIsEmpty
    }
    
    
    @IBOutlet weak var FriendsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FriendsTableView.delegate = self
        FriendsTableView.dataSource = self
        FriendsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FriendTableView")
        
        //MARK: Запрос API
        apiservice.getFriends { [weak self] user in
            guard let self = self else { return }
            self.friends = user
            self.FriendsTableView.reloadData()
        }
        apisevicePhoto.getPhoto { [weak self ] photo in
            guard let self = self else { return }
            self.photos = photo!.response.items
            self.FriendsTableView.reloadData()
        }
        
        //MARK: Search Bar Delegate
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchBar
        definesPresentationContext = true
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterFriendsArray.count
        } else {
            return friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FriendsTableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
        
        var friendsSearch: ItemFriends
        if isFiltering {
            friendsSearch = filterFriendsArray[indexPath.row]
        } else {
            friendsSearch  = friends[indexPath.row]
        }
        
        cell.labelFriends.text = "\(friendsSearch.firstName) \(friendsSearch.lastName ?? "")"
        cell.imageFriend.sd_setImage(with: URL(string: friendsSearch.photo100), placeholderImage: UIImage())
        
        
        //MARK: Применение flyweight для дз 
        if friendsSearch.online == 0 {
            cell.onlineButton.tintColor = UIColor.redColor
            cell.onlineLabel.text = "Offline"
        } else {
            cell.onlineButton.tintColor = UIColor.greenColor
            cell.onlineLabel.text = "Online"
        }
        return cell
    }
    
    //MARK: Переход на профайл
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "goToProfile") as! ProfileFriendsViewController
        guard let indexPath = FriendsTableView.indexPathForSelectedRow else { return }
        let userProfile = friends[indexPath.row]
        let userPhoto = photos[indexPath.row]
        vc.friends = [userProfile]
        vc.photos = [userPhoto]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
extension FriendsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContextForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContextForSearchText (_ searchText: String) {
        filterFriendsArray = friends.filter({ ( searchFriend: ItemFriends) -> Bool in
            return searchFriend.firstName.lowercased().contains(searchText.lowercased())
            
        })
        FriendsTableView.reloadData()
    }
}


