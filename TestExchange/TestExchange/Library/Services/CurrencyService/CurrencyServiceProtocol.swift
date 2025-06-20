//
//  CurrencyServiceProtocol 2.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

protocol CurrencyServiceProtocol {
    func getAvailableCurrencies() async throws -> [Currency]
    func getCurrencyRate(from: Currency, to: Currency) async throws -> Double
}
