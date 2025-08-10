import Foundation
import Alamofire

protocol Api {
    
    static var baseURL: String { get }
    var key: String { get }
    var headers: HTTPHeaders { get }
    
    func createEndpoint(path: String, method: HTTPMethod, query: Parameters?, body: Parameters?) -> Endpoint
}