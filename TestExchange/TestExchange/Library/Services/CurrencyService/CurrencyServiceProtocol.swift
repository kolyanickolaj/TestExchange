//
//  CurrencyServiceProtocol 2.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

protocol CurrencyServiceProtocol {
    func getAvailableCurrencies(forceRefresh: Bool) async throws -> [Currency]
    func getCurrencyRate(from: Currency, to: Currency, forceRefresh: Bool) async throws -> RateResult
}

final class MockCurrencyService: CurrencyServiceProtocol {
    func getAvailableCurrencies(forceRefresh: Bool) async throws -> [Currency] {
        throw CurrencyServiceError.noData
    }
    
    func getCurrencyRate(from: Currency, to: Currency, forceRefresh: Bool) async throws -> RateResult {
        throw CurrencyServiceError.noData
    }
}
