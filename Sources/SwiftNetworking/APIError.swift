//
//  APIError.swift
//  SwiftNetworking
//
//  Created by Saurabh Verma on 16/01/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidHTTPMethod
    case invalidHTTPStatusCode
    case invalidResponseData
    case decodingError
    case serverError
}
