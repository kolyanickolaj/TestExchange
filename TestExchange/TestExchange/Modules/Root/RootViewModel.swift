//
//  RootViewModel.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//

import Foundation
import Combine

final class RootViewModel: ObservableObject {
    private let context: AppContext
    
    init(
        context: AppContext = Context()
    ) {
        self.context = context
    }
    
    var homeView: HomeView {
        HomeView(
            viewModel:
                HomeViewModel(
                    currencyService: context.currencyService,
                    storage: context.coreDataStorage,
                    reachabilityService: context.reachabilityService
                )
        )
    }
}
