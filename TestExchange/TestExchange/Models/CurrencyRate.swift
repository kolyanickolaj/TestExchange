//
//  CurrencyRate.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//
import Foundation
import CoreData

struct CurrencyRate {
    let code: String
    let value: Double
}

extension CurrencyRate: Persistable {
    static var entityName: String { "DBCurrencyRate" }

    func createDB(in context: NSManagedObjectContext) -> DBCurrencyRate {
        let object = createPersistanceObject(context, entityName: Self.entityName)
        object.code = code
        object.value = value
        return object
    }
    
    static func from(_ model: DBCurrencyRate) throws -> Self {
        .init(
            code: model.code ?? "",
            value: model.value
        )
    }
}

extension CurrencyRate: Filterable {
    func stringValue(forKey key: FilterableKey) -> String? {
        switch key {
        case .code: return code
        case .value: return "\(value)"
        default: return nil
        }
    }
}
