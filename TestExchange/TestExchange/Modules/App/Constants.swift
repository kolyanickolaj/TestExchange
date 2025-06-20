//
//  Constants.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 19.06.25.
//

import Foundation

enum Constants {
    enum FreeCurrencyExhange {
        static let apiKey: String = "fca_live_44AbFZsw0JiHnm0J9EZtod4zeifnOoSorWAMcHLn"
        static let currenciesUrlString: String = "https://api.freecurrencyapi.com/v1/currencies"
        static let rateUrlString: String = "https://api.freecurrencyapi.com/v1/latest"
    }
    
    static let defaultCurrencies: [String] = ["USD", "EUR", "RUB", "GBP", "CHF", "CNY"]
    static let freshCurrenciesInterval: TimeInterval = 60 * 60 * 24
    static let freshRateInterval: TimeInterval = 60
}
