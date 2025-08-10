import Alamofire

class AlamofireManager {
    static let shared = AlamofireManager()
    private init() {}
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return Session(configuration: configuration)
    }()
    
    func request<T: Decodable>(url: URLRequestConvertible, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        session.request(url)
        .validate()
        .responseDecodable(of: responseType) { [weak self] response in
            self?.handleResponse(response, completion: completion)
        }
    }
    
    // MARK: - Response Handler
    private func handleResponse<T: Decodable>(
        _ response: AFDataResponse<T>,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        switch response.result {
        case .success(let data):
            completion(.success(data))
        case .failure(let error):
            completion(.failure(handleError(error, response: response)))
        }
    }
    
    // MARK: - Error Handler
    private func handleError<T>(
        _ error: AFError,
        response: AFDataResponse<T>
    ) -> NetworkError {
        if case .responseValidationFailed(let reason) = error {
            switch reason {
            case .unacceptableStatusCode(let code):
                let message = response.data.flatMap { String(data: $0, encoding: .utf8) }
                return .serverError(code, message)
            default:
                return .networkError(error)
            }
        }
        return .networkError(error)
    } 
}