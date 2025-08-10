import Foundation
import Alamofire

class UserLocalApi: Api {
    
    static let baseURL: String = "https://192.168.100.104:8000"
    
    let key: String = ""
    var headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    internal func createEndpoint(path: String, method: HTTPMethod, query: Parameters? = nil, body: Parameters? = nil) -> Endpoint {
        return Endpoint(
            baseURL: UserLocalApi.baseURL,
            headers: headers,
            path: path,
            method: method,
            query: query,
            body: body
        )
    }

}

extension UserLocalApi {
    
    func get(email: String, password: String) -> Endpoint {
        return createEndpoint(path: "user", method: .get, query: ["email": email, "password": password])
    }

    func getAll() -> Endpoint {
        return createEndpoint(path: "users", method: .get)
    }
    
    func add(name: String, email: String, password: String, role: String, createdAt: String) -> Endpoint {
        let body = [
            "name": name,
            "email": email,
            "password": password,
            "role": role,
            "createdAt": createdAt,
            "updatedAt": createdAt
        ]
        return createEndpoint(path: "user", method: .post, body: body)
    }

    func update(id: Int, name: String?, email: String?, password: String?, role: String?, updatedAt: String) -> Endpoint {
        var body: [String: Any] = ["updatedAt": updatedAt]
        if let name = name { body["name"] = name }
        if let email = email { body["email"] = email }
        if let password = password { body["password"] = password }
        if let role = role { body["role"] = role }
        return createEndpoint(path: "users/\(id)", method: .put, body: body)
    }

    func delete(id: Int) -> Endpoint {
        return createEndpoint(path: "users/\(id)", method: .delete)
    }
    
}