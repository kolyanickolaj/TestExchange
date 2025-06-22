//
//  FreeCurrencyProvider.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 19.06.25.
//

import Foundation
import Combine

final class FreeCurrencyProvider: CurrencyExchangeProviderProtocol {
    private let fetcher: GenericAPI
    
    init(fetcher: GenericAPI = Fetcher()) {
        self.fetcher = fetcher
    }
    
    func getCurrencies() async throws -> [Currency] {
        struct Response: Codable {
            let data: [String: Currency]
        }
        
        guard let url = URL(string: Constants.FreeCurrencyExhange.currenciesUrlString) else {
            throw ApiError.requestFailed(description: "Invalid URL")
        }
        
        let apiKey: URLQueryItem = .init(name: "apikey", value: Constants.FreeCurrencyExhange.apiKey)
        let currencies: URLQueryItem = .init(name: "currencies", value: Constants.defaultCurrencies.joined(separator: ","))
        
        let result: Response = try await fetcher.fetch(request: URLRequest(url: url.appending(queryItems: [apiKey, currencies])))
        return result.data.map({ $0.value })
    }
    
    func getRate(base: Currency, target: [Currency]) async throws -> [CurrencyRate] {
        struct Response: Codable {
            let data: [String: Double]
        }

        guard let url = URL(string: Constants.FreeCurrencyExhange.rateUrlString) else {
            throw ApiError.requestFailed(description: "Invalid URL")
        }
        
        let apiKey: URLQueryItem = .init(name: "apikey", value: Constants.FreeCurrencyExhange.apiKey)
        let currencies: URLQueryItem = .init(name: "currencies", value: target.map({ $0.code }).joined(separator: ","))
        let base: URLQueryItem = .init(name: "base_currency", value: base.code)
        
        let result: Response = try await fetcher.fetch(request: URLRequest(url: url.appending(queryItems: [apiKey, currencies, base])))
        return result.data.map { key, value in
            CurrencyRate(code: key, value: value)
        }
    }
}
