//
//  APIError.swift
//  SwiftNetworking
//
//  Created by Saurabh Verma on 16/01/25.
//

import Foundation

/// An enumeration of possible errors that can occur during API operations.
public enum APIError: Error {
    
    /// Indicates that the server returned an unexpected response type.
    case unexpectedResponse
    
    /// Represents network-related errors.
    /// - Parameter error: The `URLError` instance describing the network error.
    case networkError(URLError)
    
    /// Captures client-side errors indicated by HTTP status codes in the 4xx range.
    /// - Parameter statusCode: The HTTP status code representing the client error.
    case clientError(Int)
    
    /// Represents server-side errors indicated by HTTP status codes in the 5xx range.
    /// - Parameter statusCode: The HTTP status code indicating the server error.
    case serverError(Int)
    
    /// Indicates an HTTP status code was received that wasn't expected.
    /// - Parameter statusCode: The unexpected HTTP status code.
    case unexpectedStatusCode(Int)
    
    /// Error occurred during the decoding process of received data.
    /// - Parameter error: The `Error` that caused the decoding to fail.
    case decodingFailed(Error)
    
    /// Catches all other errors not covered by the above cases.
    /// - Parameter error: The underlying error that occurred.
    case unknown(Error)
    
    /// A human-readable description of the error.
    public var localizedDescription: String {
        switch self {
        case .unexpectedResponse:
            return "Received unexpected response type."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .clientError(let statusCode):
            return "Client error with status code: \(statusCode)"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected status code: \(statusCode)"
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
