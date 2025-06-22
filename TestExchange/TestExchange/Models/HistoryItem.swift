//
//  HistoryItem.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 21.06.25.
//
import CoreData

struct HistoryItem: Hashable {
    let timestamp: Double
    let rate: Double
    let value: Double
    let base: Currency
    let target: Currency
}

extension HistoryItem: Persistable {
    static var entityName: String { "DBHistoryItem" }

    func createDB(in context: NSManagedObjectContext) -> DBHistoryItem {
        let record = createPersistanceObject(context, entityName: Self.entityName)
        record.timestamp = timestamp
        record.rate = rate
        record.value = value
        let dbCurrencyBase = base.createDB(in: context)
        let dbCurrencyTarget = target.createDB(in: context)
        dbCurrencyBase.baseHistoryItem = record
        dbCurrencyTarget.targetHistoryItem = record
        return record
    }
    
    static func from(_ model: DBHistoryItem) throws -> Self {
        guard let base = model.base,
              let target = model.target
        else {
            throw CoreDataError.noSuchRelationship
        }
        return HistoryItem(
            timestamp: model.timestamp,
            rate: model.rate,
            value: model.value,
            base: try Currency.from(base),
            target: try Currency.from(target)
        )
    }
}

extension HistoryItem: Filterable {
    func stringValue(forKey key: FilterableKey) -> String? {
        switch key {
        case .timestamp: return "\(timestamp)"
        case .rate: return "\(rate)"
        default: return nil
        }
    }
}

extension HistoryItem {
    static let mock: HistoryItem = .init(timestamp: 0, rate: 0, value: 0, base: .mock, target: .mock)
}
