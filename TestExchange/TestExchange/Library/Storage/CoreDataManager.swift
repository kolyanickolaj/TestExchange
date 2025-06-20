//
//  CoreDataManager.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 19.06.25.
//
import CoreData

protocol Persistable {
    associatedtype DBType: NSManagedObject
    static var entityName: String { get }

    func createDB(in context: NSManagedObjectContext) -> DBType
    static func from(_ model: DBType) throws -> Self
}

extension Persistable {
    func createPersistanceObject(_ context: NSManagedObjectContext, entityName: String) -> DBType {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? DBType else {
            fatalError("Can't find model \(DBType.self)")
        }
        return entity
    }
}

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

protocol StorageProtocol {
    func fetch<T: Persistable & Filterable>(with filters: [Filter]) -> T?
    func fetch<T: Persistable & Filterable>(with filters: [Filter]) -> [T]
    func save(_ object: any Persistable)
}

final class CoreDataManager: StorageProtocol {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "CurrencyModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data: \(error)")
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
    
    func fetch<T: Persistable & Filterable>(with filters: [Filter] = []) -> [T] {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
            
            if !filters.isEmpty {
                var predicates: [NSPredicate] = []
                for filter in filters {
                    predicates.append(NSPredicate(format: "\(filter.key.rawValue) \(filter.condition.rawValue) %@", "\(filter.value)"))
                }
                let compound = NSCompoundPredicate(type: .and, subpredicates: predicates)
                request.predicate = compound
            }
            
            let fetchedObjects = try context.fetch(request)
            return fetchedObjects
                .compactMap { $0 as? T.DBType }
                .compactMap { try? T.from($0) }
        } catch {
            print(error)
            return []
        }
    }

    func fetch<T: Persistable & Filterable>(with filters: [Filter] = []) -> T? {
        fetch(with: filters).first
    }
}
