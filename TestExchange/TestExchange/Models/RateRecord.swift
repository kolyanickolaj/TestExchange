//
//  RateRecord.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

import Foundation
import CoreData

struct RateRecord {
    let timestamp: Double
    let base: Currency
    let rates: [CurrencyRate]
}

extension RateRecord: Persistable {
    static var entityName: String { "DBRateRecord" }

    func createDB(in context: NSManagedObjectContext) -> DBRateRecord {
        let record = createPersistanceObject(context, entityName: Self.entityName)
        record.timestamp = timestamp
        for rate in rates {
            let dbRate = rate.createDB(in: context)
            dbRate.record = record
        }
        let dbCurrency = base.createDB(in: context)
        dbCurrency.rate = record
        return record
    }
    
    static func from(_ model: DBRateRecord) throws -> Self {
        guard let base = model.base else {
            throw CoreDataError.noSuchRelationship
        }
        
        let rates: [CurrencyRate] = (model.rates as? Set<DBCurrencyRate> ?? []).map {
            CurrencyRate(code: $0.code ?? "", value: $0.value)
        }

        return RateRecord(
            timestamp: model.timestamp,
            base: try Currency.from(base),
            rates: rates
        )
    }
}

extension RateRecord: Filterable {
    func stringValue(forKey key: FilterableKey) -> String? {
        switch key {
        case .timestamp: return "\(timestamp)"
        case .baseCode: return base.code
        default: return nil
        }
    }
}
