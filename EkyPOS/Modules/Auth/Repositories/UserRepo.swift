import Foundation

class UserRepo {

    private let userApi = UserLocalApi()
    private let alamofireManager = AlamofireManager.shared
    
    func login(email: String, password: String, completion: @escaping (Result<UserModel?, Error>) -> Void) {
        let url = userApi.get(email: email, password: password)
        alamofireManager.request(url: url, responseType: UserModel.self) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func register(email: String, password: String, name: String, role: String, completion: @escaping (Result<UserModel?, Error>) -> Void) {
        let createdAt = Date().toCustomISOFormat()
        let url = userApi.add(name: name, email: email, password: password, role: role, createdAt: createdAt)
        alamofireManager.request(url: url, responseType: UserModel.self) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
