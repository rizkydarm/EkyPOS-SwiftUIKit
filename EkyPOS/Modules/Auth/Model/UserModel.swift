import Foundation

class UserModel: NSObject, Decodable {
    
    let id: Int?
    let name: String?
    let email: String?
    let password: String?
    let role: String?
    let createdAt: String?
    let updatedAt: String?
    
    init(id: Int, name: String, email: String, password: String, role: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case id, name, email, password, role
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
}
