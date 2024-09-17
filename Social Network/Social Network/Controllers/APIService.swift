//
//  APIService.swift
//  Social Network
//
//  Created by Alex on 24.06.2021.
//

import Foundation
import Alamofire

final class APIService {
    
    let baseURl = "https://api.vk.com/method"
    let token = Session.shared.token1
    let userID = Session.shared.userID
    let version = "5.138"
    
    func getGroup (completion: @escaping ([Group]) -> Void ){
        let method = "/groups.get"
        
        let param: Parameters =
            [
                "user_id": Session.shared.userID,
                "extended": 1,
                "count": 30,
                "access_token": Session.shared.token1,
                "v": version
            ]
        let url = baseURl + method
        
        AF.request(url, method: .get, parameters: param).responseData { (response) in
            guard let data = response.data else { return }
            do {
            let groupResponder = try JSONDecoder().decode(Groups.self, from: data)
                let groups = groupResponder.response.items
            DispatchQueue.main.async {
                completion(groups)
            }
            print(data.prettyJSON as Any)
            } catch {
                print(error)
            }
    }
    }

    func getFriend (completion: @escaping ([Item]) -> ()){
        let method = "/friends.get"
        
        let parameters: Parameters =
            [
                "user_id": Session.shared.userID,
                "order": "name",
                "count": 30,
                "fields": "photo_100",
                "access_token": Session.shared.token1,
                "v": version
            ]
        let url = baseURl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData {  response in
            
            guard let data = response.data else { return}
            do {
            let friendResponder = try JSONDecoder().decode(Friends.self, from: data)
            let friends = friendResponder.response.items
            print(data.prettyJSON as Any)
            DispatchQueue.main.async {
                completion(friends)
            }
            } catch {
                print(error)
        }
        }
    }
    
    func getPhoto (completion: @escaping ([Photo]) -> ()) {
        let method = "/photos.get"
        
        let param: Parameters =
            [
                "album_id": "profile",
                "rev": 1,
                "count": 30,
                "access_token": Session.shared.token1,
                "v": version
            ]
        let url = baseURl + method
        AF.request(url, method: .get, parameters: param).responseData { response in
            guard let data = response.data else { return}
            do {
            let photoResponder = try JSONDecoder().decode(Photos.self, from: data)
            let photo = photoResponder.response.items
            print(data.prettyJSON as Any)
            DispatchQueue.main.async {
                completion(photo)
            }
            } catch {
                print(error)
        }
        }
        
}
}
