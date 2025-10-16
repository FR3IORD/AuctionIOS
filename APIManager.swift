// MARK: - 🌐 APIManager.swift - ყველა API-თან კომუნიკაცია

import Foundation

class APIManager {
    static let shared = APIManager()
    
    // API Base URLs
    private let baseURL = "http://192.168.10.60/auction-platform"
    private let apiURL = "http://192.168.10.60/auction-platform/api"
    
    private var session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    func initialize() {
        print("🚀 API Manager initialized with base URL: \(baseURL)")
    }
    
    // MARK: - Generic API Request
    private func performRequest<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        parameters: [String: Any]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Authorization header
        if let token = UserManager.shared.getAuthToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Parameters
        if let params = parameters {
            if method == .GET {
                // GET parameters in URL
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = components?.url
            } else {
                // POST/PUT parameters in body
                request.httpBody = try? JSONSerialization.data(withJSONObject: params)
            }
        }
        
        print("🌐 API Request: \(method.rawValue) \(endpoint)")
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Network Error: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Response Status: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode >= 400 {
                        completion(.failure(.serverError(httpResponse.statusCode)))
                        return
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    print("❌ Decode Error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    // MARK: - Authentication API Calls
    
    func login(email: String, password: String, completion: @escaping (Result<AuthResponse, APIError>) -> Void) {
        let parameters = [
            "email": email,
            "password": password
        ]
        
        performRequest(
            endpoint: "\(apiURL)/auth/login",
            method: .POST,
            parameters: parameters,
            responseType: AuthResponse.self,
            completion: completion
        )
    }
    
    func register(firstName: String, lastName: String, username: String, email: String, password: String, completion: @escaping (Result<AuthResponse, APIError>) -> Void) {
        let parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "username": username,
            "email": email,
            "password": password
        ]
        
        performRequest(
            endpoint: "\(apiURL)/auth/register",
            method: .POST,
            parameters: parameters,
            responseType: AuthResponse.self,
            completion: completion
        )
    }
    
    // MARK: - Auctions API Calls
    
    func fetchAuctions(status: String = "all", completion: @escaping (Result<AuctionsResponse, APIError>) -> Void) {
        let parameters = ["status": status]
        
        performRequest(
            endpoint: "\(apiURL)/auctions/list",
            method: .GET,
            parameters: parameters,
            responseType: AuctionsResponse.self,
            completion: completion
        )
    }
    
    func fetchAuctionDetail(id: Int, completion: @escaping (Result<AuctionDetailResponse, APIError>) -> Void) {
        let parameters = ["id": id]
        
        performRequest(
            endpoint: "\(apiURL)/auctions/detail",
            method: .GET,
            parameters: parameters,
            responseType: AuctionDetailResponse.self,
            completion: completion
        )
    }
    
    func placeBid(auctionId: Int, completion: @escaping (Result<BidResponse, APIError>) -> Void) {
        let parameters = ["auction_id": auctionId]
        
        performRequest(
            endpoint: "\(apiURL)/bids/place",
            method: .POST,
            parameters: parameters,
            responseType: BidResponse.self,
            completion: completion
        )
    }
    
    // MARK: - User API Calls
    
    func fetchUserProfile(completion: @escaping (Result<UserProfileResponse, APIError>) -> Void) {
        performRequest(
            endpoint: "\(apiURL)/user/profile",
            method: .GET,
            responseType: UserProfileResponse.self,
            completion: completion
        )
    }
    
    func fetchUserTransactions(completion: @escaping (Result<TransactionsResponse, APIError>) -> Void) {
        performRequest(
            endpoint: "\(apiURL)/transactions/list",
            method: .GET,
            responseType: TransactionsResponse.self,
            completion: completion
        )
    }
}

// MARK: - HTTP Methods & Errors
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(String)
    case noData
    case decodingError
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let message):
            return "Network error: \(message)"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let code):
            return "Server error: \(code)"
        }
    }
}
