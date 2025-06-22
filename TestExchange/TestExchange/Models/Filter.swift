//
//  Filter.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

enum FilterableKey: String {
    case timestamp, code, name, value, rate
    case baseCode = "base.code"
    case targetCode = "target.code"
}

enum FilterCondition: String {
    case contains = "CONTAINS[cd]"
    case equals = "=="
    case equalsOrMore = ">="
}

struct Filter {
    let key: FilterableKey
    let value: String
    let condition: FilterCondition
}
