//
//  ReachableServiceProtocol.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

import Combine

protocol ReachableServiceProtocol {
    var isReachable: Bool { get }
    var onReachableChanged: AnyPublisher<Bool, Never> { get }
}

protocol ReachabilityProviderProtocol {
    var isReachable: Bool { get }
    var onReachableChanged: AnyPublisher<Bool, Never> { get }
}

final class MockReachabilityService: ReachableServiceProtocol {
    var isReachable: Bool { false }
    var onReachableChanged: AnyPublisher<Bool, Never> { Just(false).eraseToAnyPublisher() }
}
