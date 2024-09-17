//
//  PhotoStruct.swift
//  Social Network
//
//  Created by Alex on 01.07.2021.
//

import Foundation
import RealmSwift

struct Photos: Codable {
    let response: ResponsePhoto
}

struct ResponsePhoto: Codable {
    let count: Int
    let items: [Photo]
}

class Photo: Object,Codable {
    @objc dynamic var albumID: Int
    let sizes: [Size]
    @objc dynamic var postID, id, date: Int
    @objc dynamic var text: String
    let lat: Double?
    let hasTags: Bool
    @objc dynamic var ownerID: Int
    let long: Double?

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case sizes
        case postID = "post_id"
        case id, date, text, lat
        case hasTags = "has_tags"
        case ownerID = "owner_id"
        case long
    }
}

struct Size: Codable {
    let width, height: Int
    let url: String
    let type: TypeEnumPhoto
}

enum TypeEnumPhoto: String, Codable {
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}
