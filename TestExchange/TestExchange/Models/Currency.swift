//
//  Currency.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 19.06.25.
//

import Foundation
import CoreData

struct Currency: Codable, Hashable, Equatable {
    let name: String
    let code: String
}

extension Currency: Persistable {
    static var entityName: String { "DBCurrency" }

    func createDB(in context: NSManagedObjectContext) -> DBCurrency {
        let object = createPersistanceObject(context, entityName: Self.entityName)
        object.code = code
        object.name = name
        return object
    }
    
    static func from(_ model: DBCurrency) throws -> Self {
        .init(
            name: model.name ?? "",
            code: model.code ?? ""
        )
    }
}

extension Currency: Filterable {
    func stringValue(forKey key: FilterableKey) -> String? {
        switch key {
        case .code: return code
        case .name: return name
        default: return nil
        }
    }
}

extension Currency {
    static let mock: Currency = .init(name: "Mock", code: "Mock")
}
