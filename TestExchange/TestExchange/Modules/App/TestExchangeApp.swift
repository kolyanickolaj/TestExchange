//
//  TestExchangeApp.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 19.06.25.
//

import SwiftUI

@main
struct TestExchangeApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel())
        }
    }
}
