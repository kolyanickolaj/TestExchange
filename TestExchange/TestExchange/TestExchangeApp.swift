//
//  TestExchangeApp.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 19.06.25.
//

import SwiftUI

@main
struct TestExchangeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
