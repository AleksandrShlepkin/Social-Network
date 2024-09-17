
import Foundation
import RealmSwift


// MARK: - Friends

struct Friends: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let count: Int
    let items: [Item]
}

// MARK: - Item
class Item: Object, Codable {
    let canAccessClosed: Bool?
    @objc dynamic var id: Int
    @objc dynamic var photo100: String
    @objc dynamic var lastName, trackCode: String
    let isClosed: Bool?
    @objc dynamic var firstName: String
    let deactivated: String?
    let lists: [Int]?

    enum CodingKeys: String, CodingKey {
        case canAccessClosed = "can_access_closed"
        case id
        case photo100 = "photo_100"
        case lastName = "last_name"
        case trackCode = "track_code"
        case isClosed = "is_closed"
        case firstName = "first_name"
        case deactivated, lists
    }
}
