//
//  Filterable.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

import CoreData

protocol Filterable {
    func stringValue(forKey key: FilterableKey) -> String?
}

extension Filterable {
    //Better to use per-type implementation
    func stringValue(forKey key: FilterableKey) -> String? {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if child.label == key.rawValue {
                return String(describing: child.value)
            }
        }
        return nil
    }
}

enum FilterLogic {
    case and, or
    
    var type: NSCompoundPredicate.LogicalType {
        switch self {
        case .and: return .and
        case .or: return .or
        }
    }
}
