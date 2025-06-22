//
//  HistoryView+Composition.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

import Combine
import Foundation
import UIKit

enum HistoryResult {
    case close
}

struct HistoryViewDependency: Identifiable {
    let id = UUID()
    let storage: StorageProtocol
    
    var publisher: any Publisher<HistoryResult, Never> {
        subject.receive(on: DispatchQueue.main)
    }

    fileprivate let subject = PassthroughSubject<HistoryResult, Never>()
}


extension HistoryView {
    init(dependency: HistoryViewDependency) {
        self.init(
            viewModel:
                HistoryViewModel(
                    storage: dependency.storage,
                    subject: dependency.subject
                )
        )
    }
}
