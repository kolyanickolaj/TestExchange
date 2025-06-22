//
//  CurrencyExhangeProviderProtocol.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

protocol CurrencyExchangeProviderProtocol {
    func getCurrencies() async throws -> [Currency]
    func getRate(base: Currency, target: [Currency]) async throws -> [CurrencyRate]
}
