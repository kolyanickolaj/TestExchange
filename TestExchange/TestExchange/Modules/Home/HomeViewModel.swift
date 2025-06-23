//
//  HomeViewModel.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

import SwiftUI
import Combine

struct CalculatedResult {
    let description: String
    let result: String
}

struct SimpleCalculatedResult {
    let descriptionFrom: String
    let descriptionTo: String
    let date: String
}

final class HomeViewModel: ObservableObject {
    @Published var amount = "100"
    @Published var fromCurrency: Currency? {
        didSet {
            if fromCurrency == toCurrency {
                toCurrency = toCurrencies.first(where: { $0 != fromCurrency }) ?? fromCurrency
            }
        }
    }
    @Published var toCurrency: Currency?
    @Published var error: HomeError? {
        didSet {
            if error == nil,
               !reachabilityService.isReachable
            {
                error = .noInternetConnection
            }
        }
    }
    @Published var result: CalculatedResult?
    @Published var simpleResult: SimpleCalculatedResult?
    @Published var historyDependency: HistoryViewDependency?
    
    var allCurrencies: [Currency] = []
    var fromCurrencies: [Currency] {
        allCurrencies
    }
    var toCurrencies: [Currency] {
        allCurrencies.filter({ $0 != fromCurrency })
    }
    
    private let currencyService: CurrencyServiceProtocol
    private let storage: StorageProtocol
    private let reachabilityService: ReachableServiceProtocol
    private var bag:Set<AnyCancellable> = []
    
    init(
        currencyService: CurrencyServiceProtocol,
        storage: StorageProtocol,
        reachabilityService: ReachableServiceProtocol
    ) {
        self.currencyService = currencyService
        self.storage = storage
        self.reachabilityService = reachabilityService
    }
    
    func onAppear() {
        getAllCurrencies()
        bind()
    }
    
    func calculateButtonTapped() {
        calculate()
    }
    
    func historyButtonTapped() {
        showHistory()
    }
    
    private func getAllCurrencies() {
        Task { @MainActor in
            do {
                allCurrencies = try await currencyService.getAvailableCurrencies()
                if fromCurrency == nil {
                    fromCurrency = allCurrencies.first(where: { $0.code == Constants.defaultFromCurrency }) ?? allCurrencies.first
                }
                if toCurrency == nil {
                    toCurrency = allCurrencies.first(where: { $0.code == Constants.defaultToCurrency }) ?? allCurrencies.filter({ $0.code != fromCurrency?.code }).first
                }
            } catch {
                self.error = .someError
            }
        }
    }
    
    private func calculate() {
        guard let fromCurrency,
              let toCurrency,
              let amountDouble = Double(amount)
        else {
            error = .incorrectInput
            return
        }
        
        Task { @MainActor in
            do {
                let rateResult = try await currencyService.getCurrencyRate(from: fromCurrency, to: toCurrency)
                
                let calcAmount = amountDouble * rateResult.value
                let calcAmountString = calcAmount.roundedPresentable
                result = CalculatedResult(
                    description: "\(amount) \(fromCurrency.code) is equal to",
                    result: "\(calcAmountString) \(toCurrency.code)"
                )
                let revertedRate: Double = 1/rateResult.value
                simpleResult = SimpleCalculatedResult(
                    descriptionFrom: "1\(fromCurrency.code) = \(rateResult.value.roundedPresentable)\(toCurrency.code)",
                    descriptionTo: "1\(toCurrency.code) = \(revertedRate.roundedPresentable)\(fromCurrency.code)",
                    date: rateResult.timeStamp.presentableDate
                )
                let historyItem = HistoryItem(
                    timestamp: Date().timeIntervalSince1970,
                    rate: rateResult.value,
                    value: amountDouble,
                    base: fromCurrency,
                    target: toCurrency
                )
                self.storage.save(historyItem)
            } catch {
                self.error = .someError
            }
        }
    }
    
    private func bind() {
        $fromCurrency
            .receive(on: RunLoop.main)
            .sink { [weak self] currency in
                self?.setupToDefault()
            }
            .store(in: &bag)
        
        $amount
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.setupToDefault()
            }
            .store(in: &bag)
        
        $toCurrency
            .receive(on: RunLoop.main)
            .sink { [weak self] currency in
                self?.setupToDefault()
            }
            .store(in: &bag)
        
        reachabilityService.onReachableChanged
            .receive(on: RunLoop.main)
            .sink { [weak self] isAvailable in
                if let error = self?.error,
                   error == .noInternetConnection,
                   isAvailable
                {
                    self?.error = nil
                } else if !isAvailable {
                    self?.error = .noInternetConnection
                }
            }
            .store(in: &bag)
    }
    
    private func setupToDefault() {
        result = nil
        simpleResult = nil
        error = nil
    }
    
    private func showHistory() {
        let dependency = HistoryViewDependency(storage: storage)
        dependency.publisher
            .sink { [weak self] result in
                switch result {
                case .close:
                    self?.historyDependency = nil
                }
            }
            .store(in: &bag)
        historyDependency = dependency
    }
}
