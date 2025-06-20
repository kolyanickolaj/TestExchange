//
//  CurrencyRecord.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

import Foundation
import CoreData

struct CurrencyRecord {
    let timestamp: Double
    let currencies: [Currency]
}

extension CurrencyRecord: Persistable {
    static var entityName: String { "DBCurrencyRecord" }

    func createDB(in context: NSManagedObjectContext) -> DBCurrencyRecord {
        let record = createPersistanceObject(context, entityName: Self.entityName)
        record.timestamp = timestamp
        for currency in currencies {
            let dbCurrency = currency.createDB(in: context)
            dbCurrency.record = record
        }
        return record
    }
    
    static func from(_ model: DBCurrencyRecord) throws -> Self {
        let currencies: [Currency] = (model.currencies as? Set<DBCurrency> ?? []).map {
            Currency(name: $0.name ?? "", code: $0.code ?? "")
        }

        return CurrencyRecord(
            timestamp: model.timestamp,
            currencies: currencies
        )
    }
}

extension CurrencyRecord: Filterable {
    func stringValue(forKey key: FilterableKey) -> String? {
        switch key {
        case .timestamp: return "\(timestamp)"
        default: return nil
        }
    }
}
