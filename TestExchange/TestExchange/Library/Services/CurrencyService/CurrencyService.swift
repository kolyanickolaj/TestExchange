//
//  CurrencyService.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

import Foundation

final class CurrencyService: CurrencyServiceProtocol {
    private let currencyProvider: CurrencyExhangeProviderProtocol
    private let storage: StorageProtocol
    
    init(
        currencyProvider: CurrencyExhangeProviderProtocol,
        storage: StorageProtocol
    ) {
        self.currencyProvider = currencyProvider
        self.storage = storage
    }
    
    func getAvailableCurrencies() async throws -> [Currency] {
        if let cachedRecord: CurrencyRecord = storage.fetch(with: []).max(by: { $0.timestamp < $1.timestamp }) {
            let recordTime = cachedRecord.timestamp
            if Date().timeIntervalSince1970 < recordTime + Constants.freshCurrenciesInterval {
                return cachedRecord.currencies
            }
        }
        
        let currencies = try await currencyProvider.getCurrencies()
        let record = CurrencyRecord(
            timestamp: Date().timeIntervalSince1970,
            currencies: currencies
        )
        storage.save(record)
        
        return currencies
    }
    
    func getCurrencyRate(from: Currency, to: Currency) async throws -> Double {
        let filter = Filter(key: .baseCode, value: from.code, condition: .equals)
        if let cachedRecord: RateRecord = storage.fetch(with: [filter]).max(by: { $0.timestamp < $1.timestamp }) {
            let recordTime = cachedRecord.timestamp
            
            if Date().timeIntervalSince1970 < recordTime + Constants.freshRateInterval,
               let rate = cachedRecord.rates.filter({ $0.code == to.code }).first
            {
                return rate.value
            }
        }
        
        let currencies = try await getAvailableCurrencies()
        let rates = try await currencyProvider.getRate(base: from, target: currencies)
        
        guard let rate = rates.filter({ $0.code == to.code }).first else {
            throw CurrencyServiceError.noData
        }
        
        let record = RateRecord(
            timestamp: Date().timeIntervalSince1970,
            base: from,
            rates: rates
        )
        storage.save(record)
        
        return rate.value
    }
}
