//
//  APIError.swift
//  SwiftNetworking
//
//  Created by Saurabh Verma on 16/01/25.
//

import Foundation

public enum APIError: Error {
    case unexpectedResponse
    case networkError(URLError)
    case clientError(Int)
    case serverError(Int)
    case unexpectedStatusCode(Int)
    case decodingFailed(Error)
    case unknown(Error)
    
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
