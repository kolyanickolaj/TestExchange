//
//  Context.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

protocol AppContext {
    var coreDataStorage: StorageProtocol { get }
    var currencyService: CurrencyServiceProtocol { get }
    var reachabilityService: ReachableServiceProtocol { get }
}

final class Context: AppContext {
    lazy var coreDataStorage: StorageProtocol = CoreDataStorage()
    
    lazy var currencyExchangeProvider: CurrencyExchangeProviderProtocol = FreeCurrencyProvider()
    
    lazy var currencyService: CurrencyServiceProtocol = CurrencyService(
        currencyProvider: currencyExchangeProvider,
        storage: coreDataStorage
    )
        
    lazy var reachabilityService: ReachableServiceProtocol = ReachableService()
}
