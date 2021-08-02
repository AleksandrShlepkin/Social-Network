//
//  File.swift
//  Social Network
//
//  Created by Alex on 23.07.2021.
//

import Foundation
import RealmSwift
import DynamicJSON
import Firebase

class NewsSecond: BaseModel{
    @objc dynamic var userID: String?
    @objc dynamic var photo: String?
    @objc dynamic var firstName: String?
    @objc dynamic var secondName: String?

    convenience required init(data: JSON) {
        self.init()
        
        self.userID = data.id.string
        self.photo = data.photo_100.string
        self.firstName = data.first_name.string
        self.secondName = data.last_name.string
    }
}



class News {
    
    let postId: Int
    let date: Int
    let text: String?
    let commentsCount: Int
    let likesCount: Int
    let userLikes:Int
    let repostsCount: Int
    let viewsCount: Int
    var urlImage: String?
    let ref: DatabaseReference?
    
    
   init(data: JSON) {
        self.ref = nil
        self.postId = data.post_id.int ?? 0
        self.date = data.date.int ?? 0
        self.text = data.text.string
        self.commentsCount = data.comments.count.int ?? 0
        self.likesCount = data.likes.count.int ?? 0
        self.userLikes = data.likes.user_likes.int ?? 0
        self.repostsCount = data.reposts.count.int ?? 0
        self.viewsCount = data.views.count.int ?? 0
        
        if let attachments = data.attachments.array {
            for attachment in attachments {
                if attachment.type.string == "photo" {
                    if let sizes = attachment.photo.sizes.array {
                        for size in sizes {
                            if size.type.string == "x" {
                                self.urlImage = size.url.string
                            }
                        }
                    }
                }
            }
        }
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let postId = value["postId"] as? Int,
            let date = value["date"] as? Int,
            let commentsCount = value["commentsCount"] as? Int,
            let likesCount = value["likesCount"] as? Int,
            let userLikes = value["userLikes"] as? Int,
            let repostsCount = value["repostsCount"] as? Int,
            let viewsCount = value["viewsCount"] as? Int
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.postId = postId
        self.date = date
        self.text = value["text"] as? String
        self.commentsCount = commentsCount
        self.likesCount = likesCount
        self.userLikes = userLikes
        self.repostsCount = repostsCount
        self.viewsCount = viewsCount
        self.urlImage = value["urlImage"] as? String
    }
    
    func toAnyObject() -> [String: Any?] {
        return [
            "postId": postId,
            "date": date,
            "text": text,
            "commentsCount": commentsCount,
            "likesCount": likesCount,
            "userLikes": userLikes,
            "repostsCount": repostsCount,
            "viewsCount": viewsCount,
            "urlImage": urlImage
        ]
    }
}

class NewsFireBase {
    let id: String
    let ref: DatabaseReference?
    
    init(id: String){
        self.ref = nil
        self.id = id
    }
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String : Any],
        let id = value["id"] as? String
        else { return nil }
        
        self.ref = snapshot.ref
        self.id = id
        
    }
    func toAnyObject() -> [String : Any]{
        return ["id" : id]
    }
    
}