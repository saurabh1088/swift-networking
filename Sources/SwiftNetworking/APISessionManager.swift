//
//  File.swift
//  SwiftNetworking
//
//  Created by Saurabh Verma on 14/01/25.
//

import Foundation

protocol APISessionManagerProtocol {
    func loadData<T: Decodable>(with request: APIRequest) async throws -> T
}

class APISessionManager: APISessionManagerProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func loadData<T: Decodable>(with request: APIRequest) async throws -> T {
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

