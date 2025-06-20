//
//  StorageProtocol.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

protocol StorageProtocol {
    func fetch<T: Persistable & Filterable>(with filters: [Filter]) -> T?
    func fetch<T: Persistable & Filterable>(with filters: [Filter]) -> [T]
    func save(_ object: any Persistable)
}
