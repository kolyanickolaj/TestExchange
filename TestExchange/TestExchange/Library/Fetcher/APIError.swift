//
//  APIError.swift
//  TestWeather
//
//  Created by Nikolai Lipski on 19.06.25.
//

import Foundation

enum ApiError: Error {
    case requestFailed(description: String)
    case invalidData
    case responseUnsuccessful(description: String)
    case jsonEncodingFailure(description: String)
    case jsonDecodingFailure(description: String)
    case jsonParsingFailure
    case failedSerialization
    case noInternet
    case readFile(url: URL)
    
    var customDescription: String {
        switch self {
        case let .requestFailed(description):
            return "Request Failed: \(description)"
        case .invalidData:
            return "Invalid Data"
        case let .responseUnsuccessful(description):
            return "Unsuccessful: \(description)"
        case let .jsonEncodingFailure(description):
            return "JSON Encoding Failure: \(description)"
        case let .jsonDecodingFailure(description):
            return "JSON Decoding Failure: \(description)"
        case .jsonParsingFailure:
            return "JSON Parsing Failure"
        case .failedSerialization:
            return "Serialization failed."
        case .readFile(let url):
            return "Read file error: \(url.path)"
        case .noInternet:
            return "No internet connection"
        }
    }
}

