//
//  ReachableService.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

import Combine

final class ReachableService: ReachableServiceProtocol {
    private let provider: ReachabilityProviderProtocol
    
    init(
        provider: ReachabilityProviderProtocol = ReachabilityProvider()
    ) {
        self.provider = provider
    }
    
    var isReachable: Bool {
        provider.isReachable
    }
    
    var onReachableChanged: AnyPublisher<Bool, Never> {
        provider.onReachableChanged
    }
}
