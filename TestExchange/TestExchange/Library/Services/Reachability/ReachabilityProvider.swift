//
//  ReachabilityProvider.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

import Combine
import Reachability

final class ReachabilityProvider: ReachabilityProviderProtocol {
    private let reachability = try! Reachability()
    
    private lazy var isRechableSubject = CurrentValueSubject<Bool, Never>(reachability.connection != .unavailable)
    lazy var onReachableChanged: AnyPublisher<Bool, Never> = isRechableSubject.eraseToAnyPublisher()
    
    private var bag: Set<AnyCancellable> = []
    
    init() {
        start()
    }
    
    var isReachable: Bool {
        isRechableSubject.value
    }
    
    func start() {
        reachability.whenReachable = { [weak self] reachability in
            self?.isRechableSubject.send(true)
        }
        
        reachability.whenUnreachable = { [weak self] reachability in
            self?.isRechableSubject.send(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
