//
//  StorageProtocol.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

protocol StorageProtocol {
    func fetch<T: Persistable & Filterable>() throws -> T?
    func fetch<T: Persistable & Filterable>() throws -> [T]
    func fetch<T: Persistable & Filterable>(with filter: Filter) throws -> T?
    func fetch<T: Persistable & Filterable>(with filter: Filter) throws -> [T]
    func fetch<T: Persistable & Filterable>(with filters: [Filter], logic: FilterLogic) throws -> T?
    func fetch<T: Persistable & Filterable>(with filters: [Filter], logic: FilterLogic) throws -> [T]
    func save(_ object: any Persistable) 
}

final class MockStorage: StorageProtocol {
    func save(_ object: any Persistable) { }
    
    func fetch<T: Persistable & Filterable>() throws -> T? {
        throw StorageError.someError
    }
    
    func fetch<T: Persistable & Filterable>() throws -> [T]  {
        throw StorageError.someError
    }
    
    func fetch<T: Persistable & Filterable>(with filters: [Filter], logic: FilterLogic) throws -> T? {
        throw StorageError.someError
    }
    
    func fetch<T: Persistable & Filterable>(with filters: [Filter], logic: FilterLogic) throws -> [T] {
        throw StorageError.someError
    }
    
    func fetch<T: Persistable & Filterable>(with filter: Filter) throws -> T? {
        throw StorageError.someError
    }
    
    func fetch<T: Persistable & Filterable>(with filter: Filter) throws -> [T] {
        throw StorageError.someError
    }
}
