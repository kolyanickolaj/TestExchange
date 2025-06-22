//
//  CurrencyServiceProtocol 2.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

protocol CurrencyServiceProtocol {
    func getAvailableCurrencies() async throws -> [Currency]
    func getCurrencyRate(from: Currency, to: Currency) async throws -> RateResult
}

final class MockCurrencyService: CurrencyServiceProtocol {
    func getAvailableCurrencies() async throws -> [Currency] {
        throw CurrencyServiceError.noData
    }
    
    func getCurrencyRate(from: Currency, to: Currency) async throws -> RateResult {
        throw CurrencyServiceError.noData
    }
}
