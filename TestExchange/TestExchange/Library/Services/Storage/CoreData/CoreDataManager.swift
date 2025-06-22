//
//  CoreDataManager.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 19.06.25.
//
import CoreData

final class CoreDataStorage: StorageProtocol {
    private let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "TestExchange")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func save(_ object: any Persistable) {
        do {
            _ = object.createDB(in: context)
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func fetch<T: Persistable & Filterable>(with filters: [Filter], logic: FilterLogic) throws -> [T] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        
        if !filters.isEmpty {
            var predicates: [NSPredicate] = []
            for filter in filters {
                predicates.append(NSPredicate(format: "\(filter.key.rawValue) \(filter.condition.rawValue) %@", "\(filter.value)"))
            }
            let compound = NSCompoundPredicate(type: logic.type, subpredicates: predicates)
            request.predicate = compound
        }
        
        return try fetch(with: request)
    }

    func fetch<T: Persistable & Filterable>(with filters: [Filter], logic: FilterLogic) throws -> T? {
        try fetch(with: filters, logic: logic).first
    }
    
    func fetch<T: Persistable & Filterable>() throws -> [T] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        return try fetch(with: request)
    }
    
    func fetch<T: Persistable & Filterable>() throws -> T? {
        try fetch().first
    }
    
    func fetch<T: Persistable & Filterable>(with filter: Filter) throws -> [T] {
        try fetch(with: [filter], logic: .and)
    }
    
    func fetch<T: Persistable & Filterable>(with filter: Filter) throws -> T? {
        try fetch(with: filter).first
    }
    
    private func fetch<T: Persistable & Filterable>(with request: NSFetchRequest<NSFetchRequestResult>) throws -> [T] {
        let fetchedObjects = try context.fetch(request)
        return fetchedObjects
            .compactMap { $0 as? T.DBType }
            .compactMap { try? T.from($0) }
    }
}
