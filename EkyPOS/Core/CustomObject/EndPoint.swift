import Foundation
import Alamofire

final class Endpoint: URLRequestConvertible {
    
    let baseURL: String
    let headers: HTTPHeaders
    let path: String
    let method: HTTPMethod
    let query: Parameters?
    let body: Parameters?
    
    // Make the initializer public for proper accessibility
    public init(
        baseURL: String,
        headers: HTTPHeaders = [:],
        path: String,
        method: HTTPMethod,
        query: Parameters? = nil,
        body: Parameters? = nil
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.path = path
        self.method = method
        self.query = query
        self.body = body
    }
    
    func asURLRequest() throws -> URLRequest {
        // Construct the full URL
        guard let url = URL(string: baseURL)?.appendingPathComponent(path) else {
            throw AFError.invalidURL(url: "\(baseURL)/\(path)")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // Set headers
        headers.forEach { header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
        }
        
        // Handle query parameters
        if let query = query, !query.isEmpty {
            do {
                urlRequest = try URLEncoding.queryString.encode(urlRequest, with: query)
            } catch {
                throw error
            }
        }
        
        // Handle body parameters
        if let body = body, !body.isEmpty {
            do {
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: body)
            } catch {
                throw error
            }
        }
        
        return urlRequest
    }
}