//
//  APIRequest.swift
//  SwiftNetworking
//
//  Created by Saurabh Verma on 14/01/25.
//

import Foundation

/// A protocol that defines the structure for an API request.
public protocol APIRequest {
    
    /// The base URL for the API endpoint.
    /// This should be the root domain where the API is hosted.
    var baseURL: String { get }
    
    /// The specific path or route for the API endpoint.
    /// This is appended to the `baseURL` to form the complete URL.
    var path: String { get }
    
    /// Optional parameters to be included in the request.
    /// These can be used for query parameters, body parameters, etc., depending on the `httpMethod`.
    var params: [String: Any]? { get }
    
    /// The HTTP method to use for the request.
    /// - Note: `HTTPMethods` is assumed to be an enum or typealias defining possible HTTP methods
    /// like .get, .post, etc.
    var httpMethod: HTTPMethods { get }
}

extension APIRequest {
    
    /// Creates and returns a `URLRequest` configured with the properties defined by the conforming type.
    ///
    /// This computed property constructs a `URLRequest` by combining the `baseURL`, `path`, and potentially the `params` if the method is GET.
    /// If the URL cannot be constructed, it will result in a fatal error with a generic error message.
    var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("Error")
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
    
    /// Constructs and returns the `URL` for the API request.
    ///
    /// This computed property builds the URL by:
    /// - Setting the base URL and path.
    /// - Adding query parameters if the HTTP method is GET and `params` are provided.
    ///
    /// - Returns: An optional `URL`. If the URL cannot be formed for any reason, `nil` is returned.
    var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        
        if httpMethod == .GET {
            guard let queryParams = params as? [String: String] else {
                return urlComponents?.url
            }
            urlComponents?.queryItems = queryParams.map({ URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        return urlComponents?.url
    }
}
