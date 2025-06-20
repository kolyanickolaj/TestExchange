//
//  GenericAPI.swift
//  TestWeather
//
//  Created by Nikolai Lipski on 19.06.25.
//

import Foundation

protocol GenericAPI {
    var session: URLSession { get }
    
    func fetch<T: Codable>(request: URLRequest) async throws -> T
    func fetchData(request: URLRequest) async throws -> Data
}

extension GenericAPI {
    func fetchData(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.requestFailed(description: "Invalid response")
        }
        
        guard httpResponse.statusCode == 200 else {
            let body = String(data: data, encoding: .utf8) ?? ""
            let code = httpResponse.statusCode
            
            throw ApiError.responseUnsuccessful(
                description: "Status code: \(code) body=\(body)"
            )
        }
        
        return data
    }
    
    func fetch<T: Codable>(request: URLRequest) async throws -> T {
        do {
            let data = try await fetchData(request: request)
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            let description = (error as NSError).description
            
            throw ApiError.jsonDecodingFailure(description: description)
        }
    }
}
