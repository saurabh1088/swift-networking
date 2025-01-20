//
//  APISessionManager.swift
//  SwiftNetworking
//
//  Created by Saurabh Verma on 14/01/25.
//

import Foundation

/// APISessionManagerProtocol define's the requirements for managing API session tasks.
///
/// This protocol provides a blueprint for types that handle network requests,
/// specifically focusing on loading data asynchronously and decoding it into a specified type.
///
/// - Note: This protocol requires iOS 13.0 or later due to the use of async/await syntax.
@available(iOS 13.0.0, *)
protocol APISessionManagerProtocol {
    
    /// Loads data from a network request and decodes it into a specified type.
    ///
    /// - Parameters:
    ///   - type: The type to decode the data into. Must conform to `Decodable`.
    ///   - request: An `APIRequest` object encapsulating the details of the network request.
    ///
    /// - Returns: An instance of type `T`, where `T` is the generic type specified.
    ///
    /// - Throws: Throws an error if the request fails, the data cannot be decoded, or if there's a network issue.
    ///
    /// - Example:
    ///   ```
    ///   struct User: Decodable {
    ///       let name: String
    ///       let email: String
    ///   }
    ///
    ///   let sessionManager: APISessionManagerProtocol = ...
    ///   let userRequest = APIRequest(url: URL(string: "https://api.example.com/user")!)
    ///
    ///   do {
    ///       let user = try await sessionManager.loadData(of: User.self, with: userRequest)
    ///       print("User name: \(user.name)")
    ///   } catch {
    ///       print("Failed to fetch user: \(error)")
    ///   }
    ///   ```
    func loadData<T: Decodable>(of type: T.Type, with request: APIRequest) async throws -> T
}

/// A concrete implementation of `APISessionManagerProtocol` for handling API session tasks.
///
/// This class manages network requests using a `URLSession` to fetch and decode data from APIs.
/// It handles different HTTP status codes, throwing specific errors based on the response status.
///
/// - Note: Available on iOS 13.0 and later to leverage async/await for asynchronous operations.
@available(iOS 13.0.0, *)
public class APISessionManager: APISessionManagerProtocol {
    
    /// The URLSession used for making network requests. Default is `URLSession.shared`.
    private let session: URLSession
    
    /// Initializes a new `APISessionManager` with an optional custom `URLSession`.
    ///
    /// - Parameter session: The `URLSession` to use for network requests. If not specified, it uses the shared session.
    /// - Example:
    ///   ```
    ///   let manager = APISessionManager()
    ///   // or with a custom session
    ///   let customSession = URLSession(configuration: .ephemeral)
    ///   let customManager = APISessionManager(session: customSession)
    ///   ```
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /// Fetches data from the network using the provided request and decodes it into the specified type.
    ///
    /// This method handles the network request, checks the HTTP status, and attempts to decode the response data.
    ///
    /// - Parameters:
    ///   - type: The type to decode the response into. Must conform to `Decodable`.
    ///   - request: An `APIRequest` object containing the details of the network request.
    ///
    /// - Returns: An instance of type `T` after successful decoding of the response data.
    ///
    /// - Throws:
    ///   - `APIError.unexpectedResponse`: If the response isn't an `HTTPURLResponse`.
    ///   - `APIError.clientError`, `APIError.serverError`: For specific HTTP status code ranges.
    ///   - `APIError.unexpectedStatusCode`: For unexpected HTTP status codes.
    ///   - Decoding errors wrapped in `APIError.decodingFailed`.
    ///
    /// - Example:
    ///   ```
    ///   struct User: Decodable {
    ///       let name: String
    ///       let email: String
    ///   }
    ///
    ///   let manager = APISessionManager()
    ///   let userRequest = APIRequest(url: URL(string: "https://api.example.com/user")!)
    ///
    ///   do {
    ///       let user = try await manager.loadData(of: User.self, with: userRequest)
    ///       print("User name: \(user.name)")
    ///   } catch {
    ///       print("Failed to fetch user: \(error)")
    ///   }
    ///   ```
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
    
    /// Decodes the given data into the specified type.
    ///
    /// This private utility method handles the decoding of `Data` into an instance of `T`.
    /// It sets up a `JSONDecoder` with a specific date decoding strategy if needed.
    ///
    /// - Parameters:
    ///   - data: The `Data` to decode.
    ///   - type: The `Decodable` type to decode into.
    ///
    /// - Returns: An instance of `T` after decoding the data.
    ///
    /// - Throws: An `APIError.decodingFailed` wrapping any error thrown during decoding.
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

