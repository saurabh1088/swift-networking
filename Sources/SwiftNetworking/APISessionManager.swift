//
//  File.swift
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
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw error
        }
    }
}

