//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/2/25.
//

import Foundation
import Combine

enum NetworkManagerError: LocalizedError {
    case unknowError
    case invalidStatus
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func get<T: Decodable>(
        with endpoint: Endpoint,
        type: T.Type,
        completion: @escaping (
            Result<T, NetworkManagerError>
        ) -> Void
    ) {
        guard let urlRequest = endpoint.request else {
            print("Unable to get request")
            completion(.failure(.unknowError))
            return
        }
        
        let task = URLSession.shared.dataTask(
            with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if let error = error {
                    print("DEBUG PRINT: \(error)")
                    completion(.failure(.unknowError))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
                    print("DEBUG PRINT: Invalid status code")
                    completion(.failure(.invalidStatus))
                    return
                }
                
                guard let data = data else {
                    print("DEBUG PRINT: Data is not available")
                    completion(.failure(.unknowError))
                    return
                }
                
                do {
                    print("DEBUG PRINT: \(response.statusCode)")
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                    return
                } catch {
                    print("DEBUG PRINT: \(error)")
                    completion(.failure(.unknowError))
                    return
                }
            }
        task.resume()
    }
    
    func getPublisher<T: Decodable>(
        with endpoint: Endpoint,
        type: T.Type
    ) -> AnyPublisher<T, NetworkManagerError> {
        guard let urlRequest = endpoint.request else {
            print("Unable to get request")
            return Fail(error: NetworkManagerError.unknowError)
                .eraseToAnyPublisher()
        }
        
       return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data, response) in
                guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
                    print("DEBUG PRINT: Invalid status code")
                    throw NetworkManagerError.invalidStatus
                }
                return data
            })
            .decode(
                type: T.self,
                decoder: {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return decoder
                }()
            )
            .mapError({ error -> NetworkManagerError in
                print(error)
                return .unknowError
            })
            .eraseToAnyPublisher()
    }
}
