import Foundation
import Alamofire

class OpenMeteoApi: Api {
    
    static let baseURL: String = "https://api.open-meteo.com/v1/"
    
    let key: String = ""
    var headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    internal func createEndpoint(path: String, method: HTTPMethod, query: Parameters? = nil, body: Parameters? = nil) -> Endpoint {
        return Endpoint(
            baseURL: OpenMeteoApi.baseURL,
            headers: headers,
            path: path,
            method: method,
            query: query,
            body: body
        )
    }

}