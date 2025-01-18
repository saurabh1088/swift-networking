//
//  APISessionManager.swift
//  SwiftNetworking
//
//  Created by Saurabh Verma on 14/01/25.
//

import Foundation

@available(iOS 13.0.0, *)
protocol APISessionManagerProtocol {
    func loadData<T: Decodable>(of type: T.Type, with request: APIRequest) async throws -> T
}

@available(iOS 13.0.0, *)
public class APISessionManager: APISessionManagerProtocol {
    private let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func loadData<T: Decodable>(of type: T.Type, with request: APIRequest) async throws -> T {
        let (data, response) = try await session.data(for: request.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unexpectedResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                throw error
            }
        case 400...499:
            throw APIError.clientError(httpResponse.statusCode)
        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    private func decode<T: Decodable>(data: Data, as type: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // Example: Adjust based on your API's date format
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}

